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
            future:
                DatabaseRecurringDeltaService().getAllRecurringDeltas(context),
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
                      deltaId: recurringDeltas[index].id);
                }),
              )));
            }));
  }
}

class RecurringDeltaButton extends StatefulWidget {
  final int deltaId;
  const RecurringDeltaButton({super.key, required this.deltaId});

  @override
  State<RecurringDeltaButton> createState() => _RecurringDeltaButtonState();
}

class _RecurringDeltaButtonState extends State<RecurringDeltaButton> {
  double _margin = 5;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListOfRecurringDeltas>(
      builder: (context, value, child) {
        RecurringDelta recurringDelta =
            value.getRecurringDelta(widget.deltaId)!;
        int remainingFrequency = recurringDelta.remainingFrequency;
        bool isComplete = recurringDelta.completedToday;

        bool canIncrement() {
          return remainingFrequency + 1 <= recurringDelta.optimalVolume;
        }

        void incrementRemaining() {
          if (canIncrement()) {
            DatabaseRecurringDeltaService()
                .deleteMostRecentCompletion(recurringDelta.id, context);
          }
        }

        void decrementRemaining() {
          DatabaseRecurringDeltaService()
              .insertNewCompletion(recurringDelta.id, context);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                          color: mainTheme.colorScheme.inverseSurface
                              .withOpacity(0.5),
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
                          context
                              .push("/recurring-deltas/${recurringDelta.id}");
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
                      color: isComplete
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
      },
    );
  }
}
