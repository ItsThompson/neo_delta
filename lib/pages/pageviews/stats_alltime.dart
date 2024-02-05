import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/stats/progress_all_time.dart';
import 'package:neo_delta/widgets/stats/stats_graph.dart';

StatsData _statsData = StatsData.generateFakeData(12, 4, -7);

class StatsPageViewAllTime extends StatefulWidget {
  const StatsPageViewAllTime({super.key});

  @override
  State<StatsPageViewAllTime> createState() => _StatsPageViewAllTimeState();
}

class _StatsPageViewAllTimeState extends State<StatsPageViewAllTime> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        AllTimeProgress(statsData: _statsData),
        StatsGraph(graphPage: StatsPageView.allTime, statsData: _statsData, maxX: _statsData.progress.length),
      ],
    ));
  }
}


// Container(
//     width: double.infinity,
//     margin: const EdgeInsets.symmetric(horizontal: 30),
//     child: Text(
//         "heelo, this paije is awl taimmm.\nshouldUpdateStats: ${context.watch<StatsFilter>().shouldUpdateStats.toString()}") // TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
//     ),
