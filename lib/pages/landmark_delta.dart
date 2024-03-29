import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/database/database_landmark_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';

class LandmarkDeltaPage extends StatefulWidget {
  final int year;
  final int month;
  const LandmarkDeltaPage({super.key, required this.year, required this.month});

  @override
  State<LandmarkDeltaPage> createState() => _LandmarkDeltaPageState();
}

class _LandmarkDeltaPageState extends State<LandmarkDeltaPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LandmarkDelta>>(
        future: widget.month == 0
            ? DatabaseLandmarkDeltaService().getAllLandmarkDeltasWithYear(widget.year)
            : DatabaseLandmarkDeltaService().getAllLandmarkDeltasWithYearAndMonth(
                widget.year, widget.month),
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
            List<LandmarkDelta> allLandmarkDeltas = snapshot.data!;
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
                      String route = "/landmark-delta-full-page/${allLandmarkDeltas[index].id}";
                      context.replace("$route?year=${widget.year}&month=${widget.month}");
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
                                snapshot.data![index].name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "${allLandmarkDeltas[index].dateTime.year}-${allLandmarkDeltas[index].dateTime.month.toString().padLeft(2, "0")}-${allLandmarkDeltas[index].dateTime.day.toString().padLeft(2, "0")}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 80,
                              child: Text(
                                allLandmarkDeltas[index].description,
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
        });
  }
}
