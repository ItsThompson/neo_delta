import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/app_bar_with_back_button.dart';
import 'package:neo_delta/widgets/stats/progress_monthly.dart';

class RecurringDeltaPageData {
  final String name;
  final double successPercentage;
  final DeltaInterval interval;
  final int minimumVolume;
  final int effectiveVolume;
  final int optimalVolume;
  final int weighting;
  final DateTime startDate;
  final int longestStreak;
  final double allTimeDeltaPercentage;
  final double currentMonthDeltaPercentage;

  RecurringDeltaPageData(
      {required this.name,
      required this.successPercentage,
      required this.interval,
      required this.minimumVolume,
      required this.effectiveVolume,
      required this.optimalVolume,
      required this.weighting,
      required this.startDate,
      required this.longestStreak,
      required this.allTimeDeltaPercentage,
      required this.currentMonthDeltaPercentage});

  static Future<RecurringDeltaPageData> getData(int deltaId, BuildContext context) async {
    RecurringDelta recurringDelta =
        await DatabaseRecurringDeltaService().getRecurringDeltaById(deltaId, context);

    double successPercentage = await DatabaseRecurringDeltaService()
        .getRecurringDeltaSuccessRateFromRecurringDelta(recurringDelta);
    int longestStreak =
        await DatabaseRecurringDeltaService().getLongestStreakFromRecurringDelta(recurringDelta);


    double allTimeDeltaPercentage = await DatabaseRecurringDeltaService()
        .getAllTimeDeltaPercentageFromRecurringDelta(recurringDelta);


    double currentMonthDeltaPercentage = await DatabaseRecurringDeltaService()
        .getThisMonthDeltaPercentageFromRecurringDelta(recurringDelta);

    return RecurringDeltaPageData(
        name: recurringDelta.name,
        successPercentage: successPercentage,
        interval: recurringDelta.deltaInterval,
        minimumVolume: recurringDelta.minimumVolume,
        effectiveVolume: recurringDelta.effectiveVolume,
        optimalVolume: recurringDelta.optimalVolume,
        weighting: recurringDelta.weighting,
        startDate: recurringDelta.startDate,
        longestStreak: longestStreak,
        allTimeDeltaPercentage: allTimeDeltaPercentage,
        currentMonthDeltaPercentage: currentMonthDeltaPercentage);
  }
}

class RecurringDeltaPage extends StatefulWidget {
  final int id;
  const RecurringDeltaPage({super.key, required this.id});

  @override
  State<RecurringDeltaPage> createState() => _RecurringDeltaPageState();
}

class _RecurringDeltaPageState extends State<RecurringDeltaPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecurringDeltaPageData>(
        future: RecurringDeltaPageData.getData(widget.id, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: mainTheme.colorScheme.primary,
            ));
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text('No data'),
            );
          }

          RecurringDeltaPageData recurringDeltaPageData = snapshot.data!;

          return Scaffold(
              appBar: const AppBarWithBackButton(title: "RECURRING DELTA"),
              body: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        recurringDeltaPageData.name,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    const SizedBox(height: 30),
                    IntrinsicHeight(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SuccessPieChart(
                              percentage:
                                  recurringDeltaPageData.successPercentage),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: mainTheme.colorScheme.surface),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 140,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Delta Profile",
                                            style: TextStyle(fontSize: 16)),
                                        Text(
                                            "${deltaIntervalAdverbString(recurringDeltaPageData.interval)} TASK",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "MV: ${recurringDeltaPageData.minimumVolume} ${recurringDeltaPageData.minimumVolume == 1 ? "TIME" : "TIMES"} / ${deltaIntervalPeriodString(recurringDeltaPageData.interval)}",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "EV: ${recurringDeltaPageData.effectiveVolume} ${recurringDeltaPageData.effectiveVolume == 1 ? "TIME" : "TIMES"} / ${deltaIntervalPeriodString(recurringDeltaPageData.interval)}",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "OV: ${recurringDeltaPageData.optimalVolume} ${recurringDeltaPageData.optimalVolume == 1 ? "TIME" : "TIMES"} / ${deltaIntervalPeriodString(recurringDeltaPageData.interval)}",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "WEIGHTING: ${recurringDeltaPageData.weighting}/10",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                        "STARTED ON ${recurringDeltaPageData.startDate.year}-${recurringDeltaPageData.startDate.month.toString().padLeft(2, "0")}-${recurringDeltaPageData.startDate.day.toString().padLeft(2, "0")}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: mainTheme
                                                .colorScheme.inverseSurface
                                                .withOpacity(0.5))),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: mainTheme.colorScheme.surface),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "LONGEST STREAK ${recurringDeltaPageData.longestStreak}",
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              "ALL TIME DELTA: ${recurringDeltaPageData.allTimeDeltaPercentage.toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              "THIS MONTH'S DELTA: ${recurringDeltaPageData.currentMonthDeltaPercentage.toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        "This Month",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    MonthlyProgress(
                        statsData: StatsData.generateFakeData(
                            28, 1, -1)) // TODO: Implement shit ykwim
                  ],
                ),
              ));
        });
  }
}

class SuccessPieChart extends StatefulWidget {
  final double percentage;
  const SuccessPieChart({super.key, required this.percentage});

  @override
  State<SuccessPieChart> createState() => _SuccessPieChartState();
}

class _SuccessPieChartState extends State<SuccessPieChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                  startDegreeOffset: -90,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${widget.percentage}%"),
                const Text("SUCCESS"),
              ],
            )
          ],
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      const double radius = 25;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: mainTheme.colorScheme.primary,
            value: widget.percentage,
            radius: radius,
            showTitle: false,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.transparent,
            value: 100 - widget.percentage,
            radius: radius,
            showTitle: false,
          );
        default:
          throw Error();
      }
    });
  }
}
