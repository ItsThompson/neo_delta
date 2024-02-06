import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/months.dart';

Map<int, int> getMonthsAndNumberOfLandmarks() {
  Map<int, int> someReturnValue = {
    1: 1,
    7: 2,
    8: 3,
    10: 1,
    12: 1
  }; // DateTime: month [1..12].
  int totalNumberOfLandmarks = 0;
  for (var value in someReturnValue.values) {
    totalNumberOfLandmarks += value;
  }
  someReturnValue[0] = totalNumberOfLandmarks;
  return someReturnValue;
}

class LandmarkDeltaMonthSelection extends StatelessWidget {
  final int year;
  const LandmarkDeltaMonthSelection({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    Map<int, int> possibleMonthsAndNumberOfLandmarks =
        getMonthsAndNumberOfLandmarks();
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: possibleMonthsAndNumberOfLandmarks.length,
          itemBuilder: (BuildContext context, int index) {
            MapEntry<int, int> monthAndNumberOfLandmarks =
                possibleMonthsAndNumberOfLandmarks.entries.elementAt(index);
            return GestureDetector(
                onTap: () {
                  // NOTE: context.go() and context.push() will produce a bug and is a current issue with gorouter: https://github.com/flutter/flutter/issues/122972
                  context.replace(
                      "/landmark-deltas/$year/${monthAndNumberOfLandmarks.key}");
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        monthAndNumberOfLandmarks.key == 0 ? "ALL YEAR" : monthsOfTheYear[monthAndNumberOfLandmarks.key - 1]
                            .month,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${monthAndNumberOfLandmarks.value}",
                            style: TextStyle(
                              color: mainTheme.colorScheme.inverseSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      )
                    ],
                  ),
                ));
          },
        ));
  }
}
