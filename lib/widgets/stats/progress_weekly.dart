import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';

class WeeklyProgress extends StatefulWidget {
  final StatsData statsData;
  const WeeklyProgress({super.key, required this.statsData});

  @override
  State<WeeklyProgress> createState() => _WeeklyProgressState();
}

class _WeeklyProgressState extends State<WeeklyProgress> {
  List<String> titles = ['MON', 'TUE', 'WED', 'THUR', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    (double, double) range = widget.statsData.getMinMax();

    return AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          child: BarChart(
            BarChartData(
              minY: range.$1 -
                  ((range.$2 - range.$1) * 0.25), // minY - (range * .25)
              maxY: range.$2 +
                  ((range.$2 - range.$1) * 0.25), // maxY + (range * .25)
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              extraLinesData: ExtraLinesData(horizontalLines: [
                HorizontalLine(
                    y: 0,
                    color: mainTheme.colorScheme.inversePrimary,
                    strokeWidth: 3)
              ]),
            ),
          ),
        ));
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 5,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return rod.toY == 0
                ? BarTooltipItem("", const TextStyle())
                : BarTooltipItem(
                    rod.toY.toStringAsFixed(2),
                    TextStyle(
                      color: rod.toY > 0
                          ? mainTheme.colorScheme.primary
                          : (rod.toY == 0
                              ? mainTheme.colorScheme.inversePrimary
                              : mainTheme.colorScheme.tertiary),
                      fontWeight: FontWeight.bold,
                    ),
                  );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: mainTheme.colorScheme.inversePrimary,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(titles[value.toInt()], style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  List<BarChartGroupData> get barGroups {
    BarChartGroupData generateBarGroup(int index, double value) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            width: 30,
            toY: value,
            borderRadius: value > 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  )
                : (value == 0
                    ? const BorderRadius.all(Radius.circular(0))
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )),
            color: value > 0
                ? mainTheme.colorScheme.primary.withOpacity(0.8)
                : (value == 0
                    ? mainTheme.colorScheme.inversePrimary.withOpacity(0.8)
                    : mainTheme.colorScheme.tertiary.withOpacity(0.8)),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }

    double getValue(index) {
      if (index + 1 > widget.statsData.progress.length) {
        return 0;
      }

      return widget.statsData.progress[index].$2;
    }

    // NOTE: ASSUMES THAT THE FIRST ELEM IS MONDAY
    return List.generate(
        7, (index) => generateBarGroup(index, getValue(index)));
  }
}
