import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/stats/progress_monthly.dart';
import 'package:neo_delta/widgets/stats/stats_graph.dart';

StatsData _statsData = StatsData.generateFakeData(20, 5, -5);

class StatsPageViewMonth extends StatefulWidget {
  const StatsPageViewMonth({super.key});

  @override
  State<StatsPageViewMonth> createState() => _StatsPageViewMonthState();
}

class _StatsPageViewMonthState extends State<StatsPageViewMonth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        MonthlyProgress(statsData: _statsData),
        StatsGraph(
            graphPage: StatsPageView.month, statsData: _statsData, maxX: 30),
      ],
    ));
  }
}

// TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
// context.watch<StatsFilter>().shouldUpdateStats
