import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';

LandmarkDelta getLandmarkDeltaById(int id) {
  return LandmarkDelta(
      id: id,
      name: "MENTORED AND DEVELOPED THREE TEAM MEMBERS",
      dateTime: DateTime.utc(2024, 2, 25),
      weighting: 10,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem.");
}

class LandmarkDeltaFullPage extends StatelessWidget {
  final int id;
  const LandmarkDeltaFullPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    LandmarkDelta landmarkDelta = getLandmarkDeltaById(id);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            landmarkDelta.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 2),
            width: 50,
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: mainTheme.colorScheme.inverseSurface
                          .withOpacity(0.8))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5, bottom: 15),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${landmarkDelta.dateTime.year}-${landmarkDelta.dateTime.month.toString().padLeft(2, "0")}-${landmarkDelta.dateTime.day.toString().padLeft(2, "0")}",
                  style: const TextStyle(fontSize: 14),
                ),

              Text("ID: ${landmarkDelta.id}"),
                Text(
                  "WEIGHTING: ${landmarkDelta.weighting}/10",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(child: Text(landmarkDelta.description))
        ],
      ),
    );
  }
}
