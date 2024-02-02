import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/pages/stats_page.dart';
import 'package:neo_delta/widgets/stats_graph.dart';
import 'package:provider/provider.dart';


GraphData graphData = GraphData(progress: [
  0.85,
  2.95,
  1.35,
  0.04,
  3.5,
  2.26,
  2.53,
  3.37,
  2.82,
  3.83
]);

class StatsPageViewWeek extends StatefulWidget {
  const StatsPageViewWeek({super.key});

  @override
  State<StatsPageViewWeek> createState() => _StatsPageViewWeekState();
}

class _StatsPageViewWeekState extends State<StatsPageViewWeek> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
                "heelo, this paije is weeaak.\nshouldUpdateStats: ${context.watch<StatsFilter>().shouldUpdateStats.toString()}") // TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
            ),
        StatsGraph(graphPage: StatsPageView.week, graphData: graphData)
      ],
    );
  }
}
