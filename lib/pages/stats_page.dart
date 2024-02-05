import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/pages/pageviews/stats_alltime.dart';
import 'package:neo_delta/pages/pageviews/stats_month.dart'; 
import 'package:neo_delta/pages/pageviews/stats_week.dart';
import 'package:neo_delta/widgets/stats/page_view_indicator.dart';
import 'package:neo_delta/widgets/stats/stats_filter_bottom_modal.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  // Is set as the first pageview
  StatsPageView currentPageView = StatsPageView.week;

  // src: https://stackoverflow.com/questions/60583201/how-to-get-the-number-of-pages-in-pageview-to-be-used-in-a-line-indicator-in-flu
  final List<Widget> _pages = [
    const StatsPageViewWeek(),
    const StatsPageViewMonth(),
    const StatsPageViewAllTime(),
  ];

  // src: https://pmatatias.medium.com/today-i-learned-better-ways-to-initialize-provider-before-context-available-9c69d3a90f9e
  // src: https://stackoverflow.com/questions/60343605/how-to-use-data-from-provider-during-initstate-in-flutter-application
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<StatsPageViewIndex>().length = _pages.length;
    // });
    Future.microtask(
        () => {context.read<StatsPageViewIndex>().length = _pages.length});
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Scaffold(
        appBar: AppBar(
            title: Text(getPageViewString(currentPageView),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
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
        body: Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  currentPageView = StatsPageView.values[index];
                  context.read<StatsPageViewIndex>().index = index;
                });
              },
              controller: pageController,
              children: _pages,
            ),
            SafeArea(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 35,
                      child: PageViewIndicator(pageController: pageController),
                    )))
          ],
        ));
  }
}
