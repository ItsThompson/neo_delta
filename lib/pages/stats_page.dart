import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/widgets/stats_filter_bottom_modal.dart';

StatsFilter filterItems = StatsFilter(filterList: [
  StatsFilterItem(name: "ALL TASKS", included: true),
  StatsFilterItem(name: "DELTA 1", included: true),
  StatsFilterItem(name: "DELTA 2", included: true),
  StatsFilterItem(name: "DELTA 3", included: true),
  StatsFilterItem(name: "DELTA 4", included: true),
  StatsFilterItem(name: "DELTA 5", included: true),
  StatsFilterItem(name: "DELTA 6", included: true),
]);

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: const Text("THIS MONTH",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          leading: 
          Container(

              margin: const EdgeInsets.only(left: 5),
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ))),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: Ink(
                decoration: ShapeDecoration(
                    color: mainTheme.colorScheme.inversePrimary,
                    shape: const CircleBorder()),
                child: IconButton(
                  onPressed: () {
                    statsFilterBottomModal(context, filterItems);
                    // showModalBottomSheet<void>(
                    //   useRootNavigator: true,
                    //   context: context,
                    //   backgroundColor: mainTheme.colorScheme.surface,
                    //   builder: (BuildContext context) =>
                    //       const SafeArea(child: StatsFilterBottomModal()),
                    // );
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
      body: Container(
        margin:
            const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 100),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text("heelo")],
        ),
      ),
    );
  }
}
