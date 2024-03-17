import 'package:flutter/material.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/widgets/stats/progress_all_time.dart';
import 'package:neo_delta/widgets/stats/stats_graph.dart';

Future<StatsData?> _generateStats(BuildContext context) async {
  if (context.mounted) {
    List<int> ids =
        await DatabaseRecurringDeltaService().getAllRecurringDeltaIds(context);
    if (context.mounted) {
      return StatsData.generateAllTimeStatsData(ids, context);
    }
  }
  return null;
}

class StatsPageViewAllTime extends StatefulWidget {
  const StatsPageViewAllTime({super.key});

  @override
  State<StatsPageViewAllTime> createState() => _StatsPageViewAllTimeState();
}

class _StatsPageViewAllTimeState extends State<StatsPageViewAllTime> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatsData?>(
        future: _generateStats(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: mainTheme.colorScheme.primary,
            ));
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text("No Data"),
            );
          }

          return SafeArea(
              child: Column(
            children: <Widget>[
              AllTimeProgress(statsData: snapshot.data!),
              StatsGraph(
                  graphPage: StatsPageView.allTime,
                  statsData: snapshot.data!,
                  maxX: snapshot.data!.progress.length),
            ],
          ));
        });
  }
}

// TODO: On "shouldUpdateStats" true: Update graphs and then set back to false
// context.watch<StatsFilter>().shouldUpdateStats
