import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/pages/stats_page.dart';
import 'package:neo_delta/widgets/stats_graph.dart';
import 'package:provider/provider.dart';

GraphData graphData = GraphData(progress: [
  -2.95,
  -0.16,
  -1.24,
  -3.59,
  -1.32,
  4.46,
  -1.01,
]);

class StatsPageViewAllTime extends StatefulWidget {
  const StatsPageViewAllTime({super.key});

  @override
  State<StatsPageViewAllTime> createState() => _StatsPageViewAllTimeState();
}

class _StatsPageViewAllTimeState extends State<StatsPageViewAllTime> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
                "heelo, this paije is awl taimmm.\nshouldUpdateStats: ${context.watch<StatsFilter>().shouldUpdateStats.toString()}") // TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
            ),
        StatsGraph(graphPage: StatsPageView.allTime, graphData: graphData)
      ],
    );
  }
}
