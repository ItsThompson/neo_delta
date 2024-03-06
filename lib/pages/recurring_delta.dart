import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/app_bar_with_back_button.dart';
import 'package:neo_delta/widgets/stats/progress_monthly.dart';

String getRecurringDeltaNameById(int id) {
  return "GYM";
}

// TODO: CALCULATIONS
double getRecurringDeltaSuccessRateFromId(int id) {
  return 50;
}

DeltaInterval getRecurringDeltaIntervalById(int id) {
  return DeltaInterval.day;
}

int getMinimumVolumeFromId(int id) {
  return 1;
}

int getEffectiveVolumeFromId(int id) {
  return 2;
}

int getOptimalVolumeFromId(int id) {
  return 4;
}

int getWeightingFromId(int id) {
  return 5;
}

DateTime getStartDateFromId(int id) {
  return DateTime.now();
}

// TODO: CALCULATIONS
int getLongestStreakFromId(int id) {
  return 5;
}

// TODO: CALCULATIONS
double getAllTimeDeltaPercentageFromId(int id) {
  return 50;
}

// TODO: CALCULATIONS
double getThisMonthDeltaPercentageFromId(int id) {
  return 4;
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
    String name = getRecurringDeltaNameById(widget.id);
    double successPercentage = getRecurringDeltaSuccessRateFromId(widget.id);
    DeltaInterval interval = getRecurringDeltaIntervalById(widget.id);
    int minimumVolume = getMinimumVolumeFromId(widget.id);
    int effectiveVolume = getEffectiveVolumeFromId(widget.id);
    int optimalVolume = getOptimalVolumeFromId(widget.id);
    int weighting = getWeightingFromId(widget.id);
    DateTime startDate = getStartDateFromId(widget.id);
    int longestStreak = getLongestStreakFromId(widget.id);
    double allTimeDeltaPercentage = getAllTimeDeltaPercentageFromId(widget.id);
    double currentMonthDeltaPercentage =
        getThisMonthDeltaPercentageFromId(widget.id);
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
                  name,
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
                    SuccessPieChart(percentage: successPercentage),
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
                            SizedBox(
                              height: 140,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Delta Profile",
                                      style: TextStyle(fontSize: 16)),
                                  Text(
                                      "${getDeltaIntervalAdverbString(interval)} TASK",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "MV: $minimumVolume ${minimumVolume == 1 ? "TIME" : "TIMES"} / ${getDeltaIntervalPeriodString(interval)}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "EV: $effectiveVolume ${effectiveVolume == 1 ? "TIME" : "TIMES"} / ${getDeltaIntervalPeriodString(interval)}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "OV: $optimalVolume ${optimalVolume == 1 ? "TIME" : "TIMES"} / ${getDeltaIntervalPeriodString(interval)}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text("WEIGHTING: $weighting/10",
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Center(
                              child: Text(
                                  "STARTED ON ${startDate.year}-${startDate.month.toString().padLeft(2, "0")}-${startDate.day.toString().padLeft(2, "0")}",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
              ),
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
                Text("SUCCESS"),
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
