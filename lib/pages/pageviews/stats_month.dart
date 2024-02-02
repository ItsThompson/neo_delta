import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/pages/stats_page.dart';
import 'package:neo_delta/widgets/stats_graph.dart';
import 'package:provider/provider.dart';

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
            child: Text("heelo, this paidge is monff.\nshouldUpdateStats: ${context.watch<StatsFilter>().shouldUpdateStats.toString()}") // TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
            ),
        const StatsGraph(graphPage: StatsPageView.month)
      ],
    );
  }
}
