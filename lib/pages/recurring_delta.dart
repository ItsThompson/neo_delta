import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/app_bar_with_back_button.dart';
import 'package:neo_delta/widgets/stats/progress_monthly.dart';

class DeltaProfile {
  final DeltaInterval interval;
  final int minimumVolume;
  final int effectiveVolume;
  final int optimalVolume;
  final int weighting;

  DeltaProfile(
      {required this.interval,
      required this.minimumVolume,
      required this.effectiveVolume,
      required this.optimalVolume,
      required this.weighting});
}

Future<DeltaProfile> getDeltaProfileData(int deltaId) async {
  DeltaInterval interval = await DatabaseRecurringDeltaService()
      .getRecurringDeltaIntervalById(deltaId);
  int minimumVolume =
      await DatabaseRecurringDeltaService().getMinimumVolumeFromId(deltaId);
  int effectiveVolume =
      await DatabaseRecurringDeltaService().getEffectiveVolumeFromId(deltaId);
  int optimalVolume =
      await DatabaseRecurringDeltaService().getOptimalVolumeFromId(deltaId);
  int weighting =
      await DatabaseRecurringDeltaService().getWeightingFromId(deltaId);

  return DeltaProfile(
      interval: interval,
      minimumVolume: minimumVolume,
      effectiveVolume: effectiveVolume,
      optimalVolume: optimalVolume,
      weighting: weighting);
}

class DeltaStats {
  final int longestStreak;
  final double allTimeDeltaPercentage;
  final double currentMonthDeltaPercentage;

  DeltaStats(
      {required this.longestStreak,
      required this.allTimeDeltaPercentage,
      required this.currentMonthDeltaPercentage});
}

Future<DeltaStats> getDeltaStats(int deltaId) async {
  int longestStreak =
      await DatabaseRecurringDeltaService().getLongestStreakFromId(deltaId);
  double allTimeDeltaPercentage = await DatabaseRecurringDeltaService()
      .getAllTimeDeltaPercentageFromId(deltaId);
  double currentMonthDeltaPercentage = await DatabaseRecurringDeltaService()
      .getThisMonthDeltaPercentageFromId(deltaId);

  return DeltaStats(
    longestStreak: longestStreak,
    allTimeDeltaPercentage: allTimeDeltaPercentage,
    currentMonthDeltaPercentage: currentMonthDeltaPercentage,
  );
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
                  child: FutureBuilder<String>(
                      future: DatabaseRecurringDeltaService()
                          .getRecurringDeltaNameById(widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            "DELTA NAME",
                            style: TextStyle(fontSize: 36),
                          );
                        }

                        return Text(
                          snapshot.data!,
                          style: const TextStyle(fontSize: 36),
                        );
                      })),
              const SizedBox(height: 30),
              IntrinsicHeight(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<double>(
                        future: DatabaseRecurringDeltaService()
                            .getRecurringDeltaSuccessRateFromId(widget.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: mainTheme.colorScheme.primary,
                            ));
                          }

                          return SuccessPieChart(percentage: snapshot.data!);
                        }),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: mainTheme.colorScheme.surface),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<DeltaProfile>(
                                future: getDeltaProfileData(widget.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: mainTheme.colorScheme.primary,
                                    ));
                                  }

                                  final DeltaInterval interval =
                                      snapshot.data!.interval;
                                  final int minimumVolume =
                                      snapshot.data!.minimumVolume;
                                  final int effectiveVolume =
                                      snapshot.data!.effectiveVolume;
                                  final int optimalVolume =
                                      snapshot.data!.optimalVolume;
                                  final int weighting =
                                      snapshot.data!.weighting;

                                  return SizedBox(
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
                                            "${getDeltaIntervalAdverbString(interval)} TASK",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "MV: $minimumVolume ${minimumVolume == 1 ? "TIME" : "TIMES"} / ${getDeltaIntervalPeriodString(interval)}",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "EV: $effectiveVolume ${effectiveVolume == 1 ? "TIME" : "TIMES"} / ${getDeltaIntervalPeriodString(interval)}",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "OV: $optimalVolume ${optimalVolume == 1 ? "TIME" : "TIMES"} / ${getDeltaIntervalPeriodString(interval)}",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text("WEIGHTING: $weighting/10",
                                            style:
                                                const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  );
                                }),
                            FutureBuilder<DateTime>(
                                future: DatabaseRecurringDeltaService()
                                    .getStartDateFromId(widget.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: mainTheme.colorScheme.primary,
                                    ));
                                  }

                                  final DateTime startDate = snapshot.data!;

                                  return Center(
                                    child: Text(
                                        "STARTED ON ${startDate.year}-${startDate.month.toString().padLeft(2, "0")}-${startDate.day.toString().padLeft(2, "0")}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: mainTheme
                                                .colorScheme.inverseSurface
                                                .withOpacity(0.5))),
                                  );
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
              const SizedBox(height: 30),
              FutureBuilder<DeltaStats>(
                  future: getDeltaStats(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: mainTheme.colorScheme.primary,
                      ));
                    }

                    final int longestStreak = snapshot.data!.longestStreak;
                    final double allTimeDeltaPercentage = snapshot.data!.allTimeDeltaPercentage;
                    final double currentMonthDeltaPercentage = snapshot.data!.currentMonthDeltaPercentage;

                    return Container(
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
                          Text("LONGEST STREAK $longestStreak",
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              "ALL TIME DELTA: ${allTimeDeltaPercentage.toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              "THIS MONTH'S DELTA: ${currentMonthDeltaPercentage.toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    );
                  }),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "This Month",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              MonthlyProgress(statsData: StatsData.generateFakeData(28, 1, -1))
            ],
          ),
        ));
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
