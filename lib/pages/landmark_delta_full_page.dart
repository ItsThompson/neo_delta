import 'package:flutter/material.dart';
import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';

class LandmarkDeltaFullPage extends StatefulWidget {
  final int id;
  const LandmarkDeltaFullPage({super.key, required this.id});

  @override
  State<LandmarkDeltaFullPage> createState() => _LandmarkDeltaFullPageState();
}

class _LandmarkDeltaFullPageState extends State<LandmarkDeltaFullPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService().getLandmarkDeltaById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: mainTheme.colorScheme.primary,
            ));
          }

          LandmarkDelta landmarkDelta = snapshot.data!;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  landmarkDelta.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
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
                  padding: const EdgeInsets.only(top: 5, bottom: 15),
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
        });
  }
}
