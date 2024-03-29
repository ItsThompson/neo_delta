import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';

class StatsGraph extends StatefulWidget {
  final StatsPageView graphPage;
  final StatsData statsData;
  final int maxX;
  const StatsGraph(
      {super.key,
      required this.graphPage,
      required this.statsData,
      required this.maxX});

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
    (double, double) range = widget.statsData.getMinMax();
    bool hasNegativeY = widget.statsData.hasNegativeValues();
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
                  color: mainTheme.colorScheme.inverseSurface,
                  strokeWidth: 2)
            ])
          : const ExtraLinesData(),
      borderData: FlBorderData(
          show: true,
          border: Border(
              left: BorderSide(
                  color: mainTheme.colorScheme.inverseSurface, width: 2),
              bottom: hasNegativeY
                  ? BorderSide.none
                  : BorderSide(
                      color: mainTheme.colorScheme.inverseSurface, width: 2))),
      minX: 0,
      maxX: widget.maxX.toDouble(),
      minY: range.$1,
      maxY: range.$2,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            widget.statsData.progress.length,
            (index) => FlSpot(
                index.toDouble(), widget.statsData.progress[index].$2)
          ),
          isCurved: true,
          color: mainTheme.colorScheme.inverseSurface,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final bool hasLandmarkDelta = widget.statsData.progress[index].$3;

              if (hasLandmarkDelta) {
                return FlDotCirclePainter(
                    color: mainTheme.colorScheme.inversePrimary);
                // TODO: hasLandmarkDelta
              }

              return const FlDotData()
                  .getDotPainter(spot, percent, barData, index);
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}
