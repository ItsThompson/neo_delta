import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:neo_delta/services/current_datetime.dart';
import 'package:neo_delta/widgets/app_bar_with_back_button.dart';
import 'package:neo_delta/widgets/buttons/inc_dec_with_label.dart';
import 'package:provider/provider.dart';

class NewRecurringPage extends StatefulWidget {
  const NewRecurringPage({super.key});

  @override
  State<NewRecurringPage> createState() => _NewRecurringPageState();
}

class _NewRecurringPageState extends State<NewRecurringPage> {
  double paddingForColumnItems = 25;
  String name = "";
  DeltaInterval interval = DeltaInterval.day;

  int minVolume = 1, effectiveVolume = 1, optimalVolume = 1, weighting = 1;

  int maxMinVol = 99,
      maxEffectiveVol = 99,
      maxOptimalVol = 99,
      maxWeighting = 10;

  bool showEmptyNameError = false;
  bool showInvalidVolumeError = false;

  minVolCallback(value) {
    minVolume = value;
  }

  effectiveVolCallback(value) {
    effectiveVolume = value;
  }

  optimalVolCallback(value) {
    optimalVolume = value;
  }

  weightingCallback(value) {
    weighting = value;
  }

  @override
  Widget build(BuildContext context) {
    bool nameIsEmpty = name == "";

    return Scaffold(
      appBar: const AppBarWithBackButton(title: "NEW RECURRING DELTA"),
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
                          helperText:
                              showEmptyNameError ? "ENTER A DELTA NAME" : null,
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
                  IncrementDecrementButton(
                      value: minVolume,
                      minValue: 0,
                      maxValue: maxMinVol,
                      labelFormat: "MINIMUM VOLUME: {}",
                      callBack: minVolCallback),
                  IncrementDecrementButton(
                      value: effectiveVolume,
                      minValue: 0,
                      maxValue: maxEffectiveVol,
                      labelFormat: "EFFECTIVE VOLUME: {}",
                      callBack: effectiveVolCallback),
                  IncrementDecrementButton(
                      value: optimalVolume,
                      minValue: 0,
                      maxValue: maxOptimalVol,
                      labelFormat: "OPTIMAL VOLUME: {}",
                      callBack: optimalVolCallback),
                  IncrementDecrementButton(
                      value: weighting,
                      minValue: 0,
                      maxValue: maxWeighting,
                      labelFormat: "WEIGHTING: {} / $maxWeighting",
                      callBack: weightingCallback),
                  Text(showInvalidVolumeError ? "ENTER A VALID VOLUME" : "",
                      style: TextStyle(color: mainTheme.colorScheme.tertiary))
                ]),
          )),
      floatingActionButton: TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
            backgroundColor: mainTheme.colorScheme.primary),
        onPressed: () {
          if (nameIsEmpty) {
            setState(() {
              showEmptyNameError = true;
            });
          } else if (!((minVolume <= effectiveVolume) &&
              (effectiveVolume <= optimalVolume))) {
            setState(() {
              showInvalidVolumeError = true;
            });
          } else {
            // Has name
            // and
            // minVolume <= effectiveVolume <= optimalVolume

            RecurringDelta newRecurringDelta = RecurringDelta(
                id: 0, // Not needed
                name: name,
                iconSrc:
                    "assets/landmark.png", // NOTE: smart icon selection (tag system?)
                deltaInterval: interval,
                weighting: weighting,
                remainingVolume: optimalVolume, // Not needed
                minimumVolume: minVolume,
                effectiveVolume: effectiveVolume,
                optimalVolume: optimalVolume,
                startDate: currentDateTime(),
                completedToday: false);

            DatabaseRecurringDeltaService()
                .insertNewRecurringDelta(newRecurringDelta);

            context.read<ListOfRecurringDeltas>().addToList(newRecurringDelta);
            context.pop();
          }
        },
        child: Text("SAVE NEW DELTA",
            style: TextStyle(
                fontSize: 20, color: mainTheme.colorScheme.inverseSurface)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
