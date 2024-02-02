import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/pages/stats_page.dart';

// src: https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/line/line_chart_sample2.dart
class StatsGraph extends StatefulWidget {
  final StatsPageView graphPage;
  const StatsGraph({super.key, required this.graphPage});

  @override
  State<StatsGraph> createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> {
  bool hasNegativeY = true;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameSize: 30,
          axisNameWidget: Text(getPageViewString(widget.graphPage)),
        ),
        leftTitles: const AxisTitles(
          axisNameSize: 30,
          axisNameWidget: Text("PROGRESS"),
        ),
      ),
      extraLinesData: hasNegativeY
          ? ExtraLinesData(horizontalLines: [
              HorizontalLine(
                  y: 0,
                  color: mainTheme.colorScheme.inversePrimary,
                  strokeWidth: 2)
            ])
          : const ExtraLinesData(),

      borderData: FlBorderData(
          show: true,
          border: Border(
              left: BorderSide(
                  color: mainTheme.colorScheme.inversePrimary, width: 2),
              bottom: hasNegativeY
                  ? BorderSide.none
                  : BorderSide(
                      color: mainTheme.colorScheme.inversePrimary, width: 2))),
      minX: 0,
      maxX: 11,
      minY: -5,
      // minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, -3),
            FlSpot(2.6, -2),
            FlSpot(4.9, -5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),

            // FlSpot(0, 3),
            // FlSpot(2.6, 2),
            // FlSpot(4.9, 5),
            // FlSpot(6.8, 3.1),
            // FlSpot(8, 4),
            // FlSpot(9.5, 3),
            // FlSpot(11, 4),
          ],
          isCurved: true,
          color: mainTheme.colorScheme.inversePrimary,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}
