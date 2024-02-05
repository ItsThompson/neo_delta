import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

enum DeltaInterval { day, week, month }

class NewRecurringPage extends StatefulWidget {
  const NewRecurringPage({super.key});

  @override
  State<NewRecurringPage> createState() => _NewRecurringPageState();
}

class _NewRecurringPageState extends State<NewRecurringPage> {
  double paddingForColumnItems = 25;
  String name = "";
  DeltaInterval interval = DeltaInterval.day;
  int _frequency = 1;
  int _weighting = 10;
  int maxWeighting = 10;
  int maxFrequency = 99;
  bool showText = false;

  int get frequency => _frequency;

  set frequency(int newFrequency) {
    if (newFrequency <= maxFrequency && newFrequency > 0) {
      _frequency = newFrequency;
    }
  }

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
          title: const Text("NEW RECURRING DELTA",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          titleSpacing: 30,
          automaticallyImplyLeading: false,
          backgroundColor: mainTheme.colorScheme.background),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: paddingForColumnItems),
                    child: TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'ENTER DELTA NAME:',
                          helperText: showText ? "ENTER A DELTA NAME" : null,
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
                      padding:
                          EdgeInsets.symmetric(vertical: paddingForColumnItems),
                      child: SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<DeltaInterval>(
                          segments: const <ButtonSegment<DeltaInterval>>[
                            ButtonSegment<DeltaInterval>(
                                value: DeltaInterval.day, label: Text("DAY")),
                            ButtonSegment<DeltaInterval>(
                                value: DeltaInterval.week, label: Text("WEEK")),
                            ButtonSegment<DeltaInterval>(
                                value: DeltaInterval.month,
                                label: Text("MONTH")),
                          ],
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return mainTheme.colorScheme.primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                          ),
                          selected: <DeltaInterval>{interval},
                          onSelectionChanged:
                              (Set<DeltaInterval> newSelection) {
                            setState(() {
                              interval = newSelection.first;
                            });
                          },
                          multiSelectionEnabled: false,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(bottom: paddingForColumnItems),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("FREQUENCY: $frequency PER DAY",
                            style: const TextStyle(fontSize: 18)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    frequency += 1;
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
                                    frequency -= 1;
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
                ]),
          )),
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
            print( "\n task name: $name\n interval: $interval\n frequency: $frequency\n weighting: $weighting"); // TODO: Business logic to write to database.
            context.pop();
          }
        },
        child: Text("SAVE NEW DELTA",
            style: TextStyle(
                fontSize: 20, color: mainTheme.colorScheme.inversePrimary)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
