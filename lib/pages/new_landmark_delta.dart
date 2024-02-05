import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

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
        appBar: AppBar(
            leading: Container(
                margin: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ))),
            title: const Text("NEW LANDMARK DELTA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            titleSpacing: 30,
            automaticallyImplyLeading: false,
            backgroundColor: mainTheme.colorScheme.background),
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
}
