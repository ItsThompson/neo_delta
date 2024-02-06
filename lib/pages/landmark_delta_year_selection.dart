import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

Map<int, int> getAllPossibleYearsAndNumberOfLandmarks() {
  return {
    2014: 12,
    2015: 5,
    2016: 10,
    2017: 8,
    2018: 2,
    2019: 5,
    2020: 3,
    2021: 9,
    2022: 12,
    2023: 8,
    2024: 9
  };
}

class LandmarkDeltaYearSelection extends StatelessWidget {
  const LandmarkDeltaYearSelection({super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, int> possibleYearsAndNumberOfLandmarks =
        getAllPossibleYearsAndNumberOfLandmarks();
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Scrollbar(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
            children: List.generate(possibleYearsAndNumberOfLandmarks.length,
                (index) {
              MapEntry<int, int> yearAndNumberOfLandmarks =
                  possibleYearsAndNumberOfLandmarks.entries.elementAt(index);
              return YearButton(
                  year: yearAndNumberOfLandmarks.key,
                  numberOfLandmarks: yearAndNumberOfLandmarks.value);
            }),
          ),
        ));
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
            if (widget.numberOfLandmarks < minimumNumberofLandmarksForMonthPage) {

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
