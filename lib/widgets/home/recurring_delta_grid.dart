import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/recurring_delta.dart';

List<RecurringDelta> recurringDeltas = [
  RecurringDelta(
    id: 0,
    name: "GYM",
    iconSrc: "assets/landmark.png",
    deltaInterval: DeltaInterval.week,
    remainingFrequency: 6,
    completedToday: false,
  ),
  RecurringDelta(
    id: 1,
    name: "PIANO",
    iconSrc: "assets/landmark.png",
    deltaInterval: DeltaInterval.month,
    remainingFrequency: 20,
    completedToday: false,
  ),
  RecurringDelta(
    id: 2,
    name: "RUN",
    iconSrc: "assets/landmark.png",
    deltaInterval: DeltaInterval.week,
    remainingFrequency: 3,
    completedToday: false,
  ),
  RecurringDelta(
    id: 3,
    name: "READ",
    iconSrc: "assets/landmark.png",
    deltaInterval: DeltaInterval.day,
    remainingFrequency: 1,
    completedToday: false,
  )
];

class RecurringDeltaGrid extends StatelessWidget {
  const RecurringDeltaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
            child: GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 25,
      crossAxisSpacing: 25,
      children: List.generate(recurringDeltas.length, (index) {
        return RecurringDeltaButton(initRecurringDelta: recurringDeltas[index]);
      }),
    )));
  }
}

class RecurringDeltaButton extends StatefulWidget {
  final RecurringDelta initRecurringDelta;
  const RecurringDeltaButton({super.key, required this.initRecurringDelta});

  @override
  State<RecurringDeltaButton> createState() => _RecurringDeltaButtonState();
}

class _RecurringDeltaButtonState extends State<RecurringDeltaButton> {
  double _margin = 5;
  bool _isComplete = false;
  RecurringDelta recurringDelta = RecurringDelta(
    id: 0,
    name: "DELTA NAME",
    iconSrc: "assets/landmark.png",
    deltaInterval: DeltaInterval.week,
    remainingFrequency: 0,
    completedToday: false,
  );
  int _remainingFrequency = 0;
  int get remainingFrequency => _remainingFrequency;
  set remainingFrequency(int newRemaining) {
    if (newRemaining >= 0) {
      _remainingFrequency = newRemaining;
    }
  }

  @override
  void initState() {
    super.initState();
    recurringDelta = widget.initRecurringDelta;
    remainingFrequency = recurringDelta.remainingFrequency;
    _isComplete = recurringDelta.completedToday;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Business logic to update database
    bool canIncrement() {
      return remainingFrequency + 1 <=
          widget.initRecurringDelta.remainingFrequency;
    }

    void incrementRemaining() {
      if (canIncrement()) {
        setState(() {
          _isComplete = false;
          remainingFrequency += 1;
        });
      }
    }

    void decrementRemaining() {
      setState(() {
        _isComplete = true;
        remainingFrequency -= 1;
      });
    }

    Future<void> doubleTapOptionBottomModal() {
      return showModalBottomSheet<void>(
        useRootNavigator: true,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            height: 180,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color:
                          mainTheme.colorScheme.inversePrimary.withOpacity(0.5),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      incrementRemaining();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            mainTheme.colorScheme.secondary)),
                    child: Text(
                      "UNDO COMPLETE",
                      style: TextStyle(
                          color: mainTheme.colorScheme.inversePrimary,
                          fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push("/recurring-deltas/${recurringDelta.id}");
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            mainTheme.colorScheme.secondary)),
                    child: Text(
                      "GO TO DELTA PROFILE",
                      style: TextStyle(
                          color: mainTheme.colorScheme.inversePrimary,
                          fontSize: 20),
                    )),
              ],
            ),
          ));
        },
      );
    }

    return SizedBox(
        height: 150,
        width: double.infinity,
        child: GestureDetector(
          // Long Press: Mark as complete
          // Double Tap: Go to profile
          onDoubleTap: () {
            // Show modal: Can increment and progress is true
            if (!canIncrement()) {
              context.push("/recurring-deltas/${recurringDelta.id}");
            } else {
              doubleTapOptionBottomModal();
            }
          },
          onLongPress: () {
            decrementRemaining();
          },
          onTapDown: (_) {
            setState(() {
              _margin = 10;
            });
          },
          onTapUp: (_) {
            setState(() {
              _margin = 5;
            });
          },
          onTapCancel: () {
            setState(() {
              _margin = 5;
            });
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.all(_margin),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 10,
                  color: _isComplete
                      ? mainTheme.colorScheme.primary
                      : Colors.transparent,
                ),
                color: remainingFrequency == 0
                    ? mainTheme.colorScheme.primary
                    : mainTheme.colorScheme.inversePrimary.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(recurringDelta.name),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset(recurringDelta.iconSrc),
                  ),
                  Text(
                    remainingFrequency == 0
                        ? "ALL DONE!"
                        : "$remainingFrequency LEFT ${getDeltaIntervalString(recurringDelta.deltaInterval)}",
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              )),
        ));
  }
}
