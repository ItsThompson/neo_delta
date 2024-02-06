import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';

// Remove when implement actual backend

List<LandmarkDelta> getLandmarkDeltaByYear(int year) {
  return [
    LandmarkDelta(
        id: 5,
        name: "PROMOTION TO SENIOR ENGINEER",
        dateTime: DateTime.utc(year, 5, 12),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 11,
        name: "SUCCESSFULLY MANAGED AND LED PROJECT NEODELTA",
        dateTime: DateTime.utc(year, 6, 16),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 15,
        name:
            "COMPLETED CERTIFICATIONS IN PROJECT MANAGEMENT AND DATA ANALYSIS.",
        dateTime: DateTime.utc(year, 8, 5),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 21,
        name:
            "SUCCESSFULLY LED A CROSS-FUNCTIONAL TEAM TO ACHIEVE A 25% INCREASE IN PRODUCTIVITY",
        dateTime: DateTime.utc(year, 9, 5),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 22,
        name: "MENTORED AND DEVELOPED THREE TEAM MEMBERS",
        dateTime: DateTime.utc(year, 11, 5),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
  ];
}

List<LandmarkDelta> getLandmarkDeltaByMonth(int year, int month) {
  return [
    LandmarkDelta(
        id: 5,
        name: "PROMOTION TO SENIOR ENGINEER",
        dateTime: DateTime.utc(year, month, 12),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 11,
        name: "SUCCESSFULLY MANAGED AND LED PROJECT NEODELTA",
        dateTime: DateTime.utc(year, month, 16),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 15,
        name:
            "COMPLETED CERTIFICATIONS IN PROJECT MANAGEMENT AND DATA ANALYSIS.",
        dateTime: DateTime.utc(year, month, 20),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 21,
        name:
            "SUCCESSFULLY LED A CROSS-FUNCTIONAL TEAM TO ACHIEVE A 25% INCREASE IN PRODUCTIVITY",
        dateTime: DateTime.utc(year, month, 22),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
    LandmarkDelta(
        id: 22,
        name: "MENTORED AND DEVELOPED THREE TEAM MEMBERS",
        dateTime: DateTime.utc(year, month, 25),
        weighting: 10,
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem."),
  ];
}

class LandmarkDeltaPage extends StatelessWidget {
  final int year;
  final int month;
  const LandmarkDeltaPage({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    List<LandmarkDelta> landmarkDeltaList = month == 0
        ? getLandmarkDeltaByYear(year)
        : getLandmarkDeltaByMonth(year, month);
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: landmarkDeltaList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Ink(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: mainTheme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: InkWell(
                    onTap: () {
                      context.replace("/landmark-delta-full-page/${landmarkDeltaList[index].id}");
                    },
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              child: Text(
                                landmarkDeltaList[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "${landmarkDeltaList[index].dateTime.year}-${landmarkDeltaList[index].dateTime.month.toString().padLeft(2, "0")}-${landmarkDeltaList[index].dateTime.day.toString().padLeft(2, "0")}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 80,
                              child: Text(
                                landmarkDeltaList[index].description,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )),
                  )),
            );
          },
        ));
  }
}

