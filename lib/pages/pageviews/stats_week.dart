import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/stats/progress_weekly.dart';
import 'package:neo_delta/widgets/stats/stats_graph.dart';

// NOTE: Default: Weeks start on MON
StatsData _statsData = StatsData.generateFakeData(7, 3, -3);

class StatsPageViewWeek extends StatefulWidget {
  const StatsPageViewWeek({super.key});

  @override
  State<StatsPageViewWeek> createState() => _StatsPageViewWeekState();
}

class _StatsPageViewWeekState extends State<StatsPageViewWeek> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        WeeklyProgress(statsData: _statsData),
        StatsGraph(graphPage: StatsPageView.week, statsData: _statsData, maxX: 7),
      ],
    ));
  }
}


// TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
// context.watch<StatsFilter>().shouldUpdateStats
