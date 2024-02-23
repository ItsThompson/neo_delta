import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';
import 'package:neo_delta/models/months.dart';

Future<Map<int, int>> getMonthsAndNumberOfLandmarks(int year) async {
  final dbService = DatabaseService();
  dbService.initDatabase();

  final List<LandmarkDelta> allLandmarkDeltas =
      await dbService.getAllLandmarkDeltas();

  Map<int, int> outputMap = {};

  for (var landmarkDelta in allLandmarkDeltas) {
    var landmarkYear = landmarkDelta.dateTime.year;
    var month = landmarkDelta.dateTime.month;

    if (year == landmarkYear) {
      outputMap.update(month, (value) => ++value, ifAbsent: () => 1);
    }
  }
  int totalNumberOfLandmarks = 0;
  for (var value in outputMap.values) {
    totalNumberOfLandmarks += value;
  }
  outputMap[0] = totalNumberOfLandmarks;

  return outputMap;
}

class LandmarkDeltaMonthSelection extends StatefulWidget {
  final int year;
  const LandmarkDeltaMonthSelection({super.key, required this.year});

  @override
  State<LandmarkDeltaMonthSelection> createState() =>
      _LandmarkDeltaMonthSelectionState();
}

class _LandmarkDeltaMonthSelectionState
    extends State<LandmarkDeltaMonthSelection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, int>>(
        future: getMonthsAndNumberOfLandmarks(widget.year),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: mainTheme.colorScheme.primary,
            ));
          }

          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Landmarks Found'),
              );
            }
          }
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  MapEntry<int, int> monthAndNumberOfLandmarks =
                      snapshot.data!.entries
                          .elementAt(index);
                  return GestureDetector(
                      onTap: () {
                        // NOTE: context.go() and context.push() will produce a bug and is a current issue with gorouter: https://github.com/flutter/flutter/issues/122972
                        context.replace(
                            "/landmark-deltas/${widget.year}/${monthAndNumberOfLandmarks.key}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              monthAndNumberOfLandmarks.key == 0
                                  ? "ALL YEAR"
                                  : monthsOfTheYear[
                                          monthAndNumberOfLandmarks.key - 1]
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
        });
  }
}
