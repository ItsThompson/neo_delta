import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';

Future<Map<int, int>> getAllPossibleYearsAndNumberOfLandmarks() async {
  final dbService = DatabaseService();
  dbService.initDatabase();

  final List<LandmarkDelta> allLandmarkDeltas =
      await dbService.getAllLandmarkDeltas();

  Map<int, int> outputMap = {};

  for (var landmarkDelta in allLandmarkDeltas) {
    var year = landmarkDelta.dateTime.year;

    outputMap.update(year, (value) => ++value, ifAbsent: () => 1);
  }
  return outputMap;
}

class LandmarkDeltaYearSelection extends StatefulWidget {
  const LandmarkDeltaYearSelection({super.key});

  @override
  State<LandmarkDeltaYearSelection> createState() =>
      _LandmarkDeltaYearSelectionState();
}

class _LandmarkDeltaYearSelectionState
    extends State<LandmarkDeltaYearSelection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, int>>(
        future: getAllPossibleYearsAndNumberOfLandmarks(),
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
              child: Scrollbar(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  children: List.generate(snapshot.data!.length, (index) {
                    MapEntry<int, int> yearAndNumberOfLandmarks =
                        snapshot.data!.entries.elementAt(index);
                    return YearButton(
                        year: yearAndNumberOfLandmarks.key,
                        numberOfLandmarks: yearAndNumberOfLandmarks.value);
                  }),
                ),
              ));
        });
  }
}

class YearButton extends StatefulWidget {
  final int year;
  final int numberOfLandmarks;
  const YearButton(
      {super.key, required this.year, required this.numberOfLandmarks});

  @override
  State<YearButton> createState() => _YearButtonState();
}

class _YearButtonState extends State<YearButton> {
  int minimumNumberofLandmarksForMonthPage = 12;

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: mainTheme.colorScheme.surface,
      ),
      child: InkWell(
          onTap: () {
            // NOTE: context.go() and context.push() will produce a bug and is a current issue with gorouter: https://github.com/flutter/flutter/issues/122972
            if (widget.numberOfLandmarks <
                minimumNumberofLandmarksForMonthPage) {
              context.replace("/landmark-deltas/${widget.year}/0");
            } else {
              context.replace("/landmark-deltas/${widget.year}");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(widget.year.toString(),
                    style: TextStyle(
                        color: mainTheme.colorScheme.primary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${widget.numberOfLandmarks} TOTAL LANDMARKS",
                        style: TextStyle(
                            color: mainTheme.colorScheme.inverseSurface
                                .withOpacity(0.5),
                            fontSize: 12)),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
