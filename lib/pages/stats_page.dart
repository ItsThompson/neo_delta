import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/pages/pageviews/stats_alltime.dart';
import 'package:neo_delta/pages/pageviews/stats_month.dart';
import 'package:neo_delta/pages/pageviews/stats_week.dart';
import 'package:neo_delta/widgets/stats_filter_bottom_modal.dart';
import 'package:provider/provider.dart';

enum StatsPageView { month, week, allTime }

String getPageViewString(StatsPageView pageView) {
  switch (pageView) {
    case StatsPageView.month:
      return "THIS MONTH";
    case StatsPageView.week:
      return "THIS WEEK";
    case StatsPageView.allTime:
      return "ALL TIME";
  }
}

class GraphData {
  final List<double> progress;

  bool hasNegativeValues() {
    for (var i = 0; i < progress.length; i++) {
      if (progress[i] < 0) {
        return true;
      }
    }
    return false;
  }

  (double, double) getRange() {
    double max = progress[0];
    double min = progress[0];
    for (var i = 1; i < progress.length; i++) {
      if (progress[i] > max) {
        max = progress[i];
      }
      if (progress[i] < min) {
        min = progress[i];
      }
    }
    return (min, max);
  }

  GraphData({required this.progress});
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsPageView currentPageView = StatsPageView.month;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Scaffold(
            extendBody: true,
            appBar: AppBar(
                title: Text(getPageViewString(currentPageView),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 32)),
                // leading: Container(
                //     margin: const EdgeInsets.only(left: 5),
                //     child: IconButton(
                //         onPressed: () {
                //           context.pop();
                //         },
                //         icon: const Icon(
                //           Icons.arrow_back_ios,
                //         ))),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: Ink(
                      decoration: ShapeDecoration(
                          color: mainTheme.colorScheme.inversePrimary,
                          shape: const CircleBorder()),
                      child: IconButton(
                        onPressed: () {
                          statsFilterBottomModal(context);
                        },
                        icon: Icon(
                          Icons.filter_list,
                          color: mainTheme.colorScheme.surface,
                        ),
                      ),
                    ),
                  )
                ],
                titleSpacing: 30,
                automaticallyImplyLeading: false,
                backgroundColor: mainTheme.colorScheme.background),
            body: PageView(
              onPageChanged: (index) {
                setState(() {
                  currentPageView = StatsPageView.values[index];
                });
              },
              controller: pageController,
              children: const <Widget>[
                StatsPageViewMonth(),
                StatsPageViewWeek(),
                StatsPageViewAllTime(),
              ],
            ));
  }
}
