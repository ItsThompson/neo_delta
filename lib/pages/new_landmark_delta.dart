import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/landmark_delta.dart';
import 'package:neo_delta/widgets/app_bar_with_back_button.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NewLandmarkPage extends StatefulWidget {
  const NewLandmarkPage({super.key});

  @override
  State<NewLandmarkPage> createState() => _NewLandmarkPageState();
}

class _NewLandmarkPageState extends State<NewLandmarkPage> {
  double paddingForColumnItems = 25;
  String name = "";
  String description = "";
  int _weighting = 10;
  int maxWeighting = 10;
  bool showText = false;
  int descriptionMaxLine = 5;

  int get weighting => _weighting;

  set weighting(int newWeighting) {
    if (newWeighting <= maxWeighting && newWeighting > 0) {
      _weighting = newWeighting;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool nameIsEmpty = name == "";
    return Scaffold(
    appBar: const AppBarWithBackButton(title: "NEW LANDMARK DELTA"),
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: paddingForColumnItems),
                    child: TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'ENTER LANDMARK:',
                          helperText:
                              showText ? "ENTER THE LANDMARK DELTA NAME" : null,
                          helperStyle:
                              TextStyle(color: mainTheme.colorScheme.tertiary)),
                      onChanged: (String value) async {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: paddingForColumnItems),
                    child: SizedBox(
                      child: TextField(
                        maxLines: descriptionMaxLine,
                        expands: false,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'DESCRIPTION:',
                        ),
                      onChanged: (String value) async {
                        setState(() {
                          description = value;
                        });
                      },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: paddingForColumnItems),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("WEIGHTING: $weighting / $maxWeighting",
                            style: const TextStyle(fontSize: 18)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    weighting += 1;
                                  });
                                },
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          mainTheme.colorScheme.inversePrimary),
                                )),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    weighting -= 1;
                                  });
                                },
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          mainTheme.colorScheme.inversePrimary),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ]))),
      floatingActionButton: TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
            backgroundColor: mainTheme.colorScheme.primary),
        onPressed: () {
          if (nameIsEmpty) {
            setState(() {
              showText = true;
            });
          } else {
            print( "\n task name: $name\n description: $description\n weighting: $weighting"); // TODO: Business logic to write to database.
            addNewLandmark(name, description, weighting);
            context.pop();
          }
        },
        child: Text("SUBMIT DELTA",
            style: TextStyle(
                fontSize: 20, color: mainTheme.colorScheme.inversePrimary)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
  }

  Future <void> addNewLandmark(String name, String description, int weighting) async {
    var now = DateTime.now();
    // Note the ID does not matter, it is autoincrementing in SQL and the insert statement does not take in an ID value.
    var landmarkDelta = LandmarkDelta(id: 0, name: name, dateTime: now, weighting: weighting, description: description);
    final dbService = DatabaseService();
    dbService.insertLandmarkData(landmarkDelta);

  }
}

