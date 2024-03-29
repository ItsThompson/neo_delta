import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:provider/provider.dart';

// src: https://medium.com/@enrico.ori/getting-to-know-flutter-advanced-use-of-modalbottomsheet-38e5ef55d561
Future<void> statsFilterBottomModal(BuildContext context) async {
  await showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Consumer<StatsFilter>(
          builder: (context, statsFilter, child) {
            bool showText = false;

            bool hasTrue(List<StatsFilterItem> filterList) {
              for (var i = 0; i < filterList.length; i++) {
                if (filterList[i].included == true) {
                  return true;
                }
              }
              return false;
            }

            List<StatsFilterItem> filterList = statsFilter.filterList;
            // context.read<StatsFilter>().filterList;
            void setIncluded(int index, bool? value) {
              if (index == 0) {
                for (var i = 0; i < filterList.length; i++) {
                  filterList[i].included = value!;
                }
              } else {
                if (value == false) {
                  filterList[0].included = false;
                }
                filterList[index].included = value!;
              }
            }

            return DraggableScrollableSheet(
                shouldCloseOnMinExtent: false,
                initialChildSize: 0.8,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) =>
                    StatefulBuilder(builder: (context, setState) {
                      return SafeArea(
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
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: mainTheme
                                            .colorScheme.inverseSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  const Text("Filter",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  // Divider
                                  Container(
                                    width: double.infinity,
                                    height: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color:
                                          mainTheme.colorScheme.inverseSurface,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: filterList.length,
                                      itemBuilder: (context, index) => ListTile(
                                        title: Text(filterList[index].name,
                                            style: index == 0
                                                ? const TextStyle(
                                                    fontWeight: FontWeight.bold)
                                                : const TextStyle()),
                                        trailing: Checkbox(
                                          value: filterList[index].included,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              setIncluded(index, value);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  showText
                                      ? Text(
                                          "Please select at least one delta", style: TextStyle(color: mainTheme.colorScheme.tertiary),)
                                      : Container(),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 100),
                                            backgroundColor:
                                                mainTheme.colorScheme.primary),
                                        onPressed: () {
                                          if (hasTrue(filterList)) {
                                            context
                                                .read<StatsFilter>()
                                                .filterList = filterList;

                                            context
                                                .read<StatsFilter>()
                                                .shouldUpdateStats = true;
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              showText = true;
                                            });
                                          }
                                        },
                                        child: Text("APPLY NOW",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: mainTheme.colorScheme
                                                    .inverseSurface))),
                                  ),

                                  Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 80),
                                              backgroundColor: mainTheme
                                                  .colorScheme.inverseSurface),
                                          onPressed: () {
                                            setState(() {
                                              setIncluded(0, false);
                                            });
                                          },
                                          child: Text("RESET",
                                              style: TextStyle(
                                                  color: mainTheme
                                                      .colorScheme.background,
                                                  fontSize: 20))))
                                ],
                              )));
                    }));
          },
        );
      });
}
