import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/pages/stats_page.dart';

// src: https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/line/line_chart_sample2.dart
class StatsGraph extends StatefulWidget {
  final StatsPageView graphPage;
  final GraphData graphData;
  const StatsGraph(
      {super.key, required this.graphPage, required this.graphData});

  @override
  State<StatsGraph> createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> {
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
    (double, double) range = widget.graphData.getRange();
    bool hasNegativeY = widget.graphData.hasNegativeValues();
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
      maxX: widget.graphData.progress.length.toDouble(),
      minY: range.$1,
      maxY: range.$2,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              widget.graphData.progress.length,
              (index) =>
                  FlSpot(index.toDouble(), widget.graphData.progress[index])),
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
