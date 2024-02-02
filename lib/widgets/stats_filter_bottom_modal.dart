import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats_filter.dart';

// src: https://medium.com/@enrico.ori/getting-to-know-flutter-advanced-use-of-modalbottomsheet-38e5ef55d561
Future<void> statsFilterBottomModal(
    BuildContext context, StatsFilter statsFilter) async {
  await showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            expand: false,
            builder: (context, scrollController) => SafeArea(
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 5, right: 25, left: 25, bottom: 25),
                    // margin: const EdgeInsets.all(25),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 50,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: mainTheme.colorScheme.inversePrimary
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text("Filter",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            )
                          ],
                        ),
                        // Dividor
                        Container(
                          width: double.infinity,
                          height: 2,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: mainTheme.colorScheme.inversePrimary,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: statsFilter.filterList.length,
                            itemBuilder: (context, index) => ListTile(
                              title: index == 0
                                  ? Text(
                                      statsFilter.filterList[index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(statsFilter.filterList[index].name),
                              trailing: Checkbox(
                                value: statsFilter.filterList[index].included,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 100),
                                  backgroundColor:
                                      mainTheme.colorScheme.primary),
                              onPressed: () {},
                              child: Text("APPLY NOW",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: mainTheme
                                          .colorScheme.inversePrimary))),
                        ),

                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 80),
                                    backgroundColor:
                                        mainTheme.colorScheme.inversePrimary),
                                onPressed: () {},
                                child: Text("RESET",
                                    style: TextStyle(
                                        color: mainTheme.colorScheme.background,
                                        fontSize: 20))))
                      ],
                    ))),
          ));
}
