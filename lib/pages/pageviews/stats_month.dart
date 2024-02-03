import 'package:flutter/material.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/pages/stats_page.dart';
import 'package:neo_delta/widgets/stats/stats_graph.dart';
import 'package:provider/provider.dart';

StatsData _statsData = StatsData.generateFakeData(30, 5, -5);

// StatsData().generateFakeData(30, 5, -5);

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
        Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
                "heelo, this paije is FFOOHSST OVE THUH MUHNFF.\nshouldUpdateStats: ${context.watch<StatsFilter>().shouldUpdateStats.toString()}") // TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
            ),
        StatsGraph(graphPage: StatsPageView.month, statsData: _statsData),
      ],
    ));
  }
}
