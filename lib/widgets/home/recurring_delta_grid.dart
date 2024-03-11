import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:provider/provider.dart';

class RecurringDeltaGrid extends StatelessWidget {
  const RecurringDeltaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListOfRecurringDeltas>(
        builder: (context, value, child) => FutureBuilder<List<RecurringDelta>>(
            future: DatabaseRecurringDeltaService().getAllRecurringDeltas(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: mainTheme.colorScheme.primary,
                ));
              }

              final List<RecurringDelta> recurringDeltas = snapshot.data!;

              if (snapshot.hasData) {
                if (recurringDeltas.isEmpty) {
                  return const Center(
                    child: Text('Create your first recurring delta!'),
                  );
                }
              }

              if (snapshot.data == null) {
                return const Center(
                  child: Text('No data'),
                );
              }

              return Expanded(
                  child: Scrollbar(
                      child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                children: List.generate(recurringDeltas.length, (index) {
                  return RecurringDeltaButton(
                      initRecurringDelta: recurringDeltas[index]);
                }),
              )));
            }));
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
  // Negative remainingFrequency means additional completions
  int remainingFrequency = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecurringDelta recurringDelta = widget.initRecurringDelta;
    remainingFrequency = recurringDelta.remainingFrequency;
    _isComplete = recurringDelta.completedToday;

    bool canIncrement() {
      return remainingFrequency + 1 <=
          widget.initRecurringDelta.remainingFrequency;
    }

    void incrementRemaining() {
      if (canIncrement()) {
        setState(() {
          _isComplete = false;
          remainingFrequency += 1;
          DatabaseRecurringDeltaService()
              .insertNewCompletion(recurringDelta.id);
        });
      }
    }

    void decrementRemaining() {
      setState(() {
        _isComplete = true;
        remainingFrequency -= 1;
        DatabaseRecurringDeltaService()
            .deleteMostRecentCompletion(recurringDelta.id);
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
                          mainTheme.colorScheme.inverseSurface.withOpacity(0.5),
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
                          color: mainTheme.colorScheme.inverseSurface,
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
                          color: mainTheme.colorScheme.inverseSurface,
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
                  width: 5,
                  color: _isComplete
                      ? remainingFrequency >= 0
                          ? mainTheme.colorScheme.primary
                          : mainTheme.colorScheme.inversePrimary
                      : Colors.transparent,
                ),
                color: remainingFrequency == 0
                    ? mainTheme.colorScheme.primary
                    : remainingFrequency >= 0
                        ? mainTheme.colorScheme.surface
                        : mainTheme.colorScheme.inversePrimary,
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
                        : remainingFrequency >= 0
                            ? "$remainingFrequency LEFT ${getDeltaIntervalCurrentString(recurringDelta.deltaInterval)}"
                            : "ALL DONE! (+${-remainingFrequency})",
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              )),
        ));
  }
}
