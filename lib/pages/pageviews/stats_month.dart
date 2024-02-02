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
  3.66,
  3.96,
  0.24,
  -2.51,
  -4.17,
  3.13,
  -0.6,
  -2.84,
  0.23,
  1.1,
  -1.82,
  -2.36,
  3.85,
  -0.85,
  2.95,
  1.35,
  0.04,
  3.5,
  -2.26,
  2.53,
  3.37,
  2.82,
  3.83
]);

class StatsPageViewMonth extends StatefulWidget {
  const StatsPageViewMonth({super.key});

  @override
  State<StatsPageViewMonth> createState() => _StatsPageViewMonthState();
}

class _StatsPageViewMonthState extends State<StatsPageViewMonth> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
                "heelo, this paije is FFOOHSST OVE THUH MUHNFF.\nshouldUpdateStats: ${context.watch<StatsFilter>().shouldUpdateStats.toString()}") // TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
            ),
        StatsGraph(graphPage: StatsPageView.month, graphData: graphData)
      ],
    );
  }
}
