import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neo_delta/database/database_landmark_delta.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/delta_progress.dart';
import 'package:neo_delta/models/landmark_delta.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:neo_delta/services/current_datetime.dart';
import 'package:provider/provider.dart';

Future<String> getRandomPhrase() async {
  Random random = Random();
  String fileString = await rootBundle.loadString("assets/data/phrases.json");

  final data = jsonDecode(fileString);
  int index = random.nextInt(data['phrases'].length);
  return data['phrases'][index];
}

Future<double> currentMonthDelta(BuildContext context) async {
  DateTime now = currentDateTime();

  List<LandmarkDelta> landmarkDeltas = await DatabaseLandmarkDeltaService()
      .getAllLandmarkDeltasWithYearAndMonth(now.year, now.month);

  double delta = 0;

  for (var landmarkDelta in landmarkDeltas) {
    delta += landmarkDelta.weighting;
  }

  if (!context.mounted) {
    return 0;
  }

  List<int> allRecurringDeltaIds =
      await DatabaseRecurringDeltaService().getAllRecurringDeltaIds(context);
  Map<int, RecurringDelta> recurringDeltas = HashMap<int, RecurringDelta>();

  for (var id in allRecurringDeltaIds) {
    RecurringDelta recurringDelta;
    if (recurringDeltas[id] == null) {
      if (!context.mounted) {
        return 0;
      }
      recurringDelta = await DatabaseRecurringDeltaService()
          .getRecurringDeltaById(id, context);
      recurringDeltas[id] = recurringDelta;
    } else {
      recurringDelta = recurringDeltas[id]!;
    }

    double currentWeightedDelta = 0;

    DateTime currentIterationStartDate = DateTime(now.year, now.month, 1);
    while (currentIterationStartDate.isBefore(now) ||
        currentIterationStartDate.isAtSameMomentAs(now)) {
      if (!context.mounted) {
        return 0;
      }
      int volume = await DatabaseRecurringDeltaService()
          .getVolumeInIntervalWithStartDate(
              id, currentIterationStartDate, context);

      currentWeightedDelta += calculateDelta(
              volume,
              recurringDelta.minimumVolume,
              recurringDelta.effectiveVolume,
              recurringDelta.optimalVolume) *
          recurringDelta.weighting;

      currentIterationStartDate = getStartOfNextDeltaInterval(
          recurringDelta.deltaInterval, currentIterationStartDate);
    }

    delta += currentWeightedDelta;
  }

  return double.parse(delta.toStringAsFixed(2));
}

TextSpan upOrDown(double delta) {
  bool isPositive = delta >= 0;
  if (isPositive) {
    return TextSpan(
        text: "up",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: mainTheme.colorScheme.primary));
  }

  return TextSpan(
      text: "down",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: mainTheme.colorScheme.tertiary));
}

Future<TextSpan> _sentenceSummaryDynamicGenerator(BuildContext context) async {
  double delta = await currentMonthDelta(context);
  String phrase = await getRandomPhrase();

  if (!context.mounted) {
    return const TextSpan();
  }

  return TextSpan(
      style: DefaultTextStyle.of(context).style,
      children: <TextSpan>[
        const TextSpan(text: "You are "),
        upOrDown(delta),
        TextSpan(
            text: " $delta% ",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: "this month. "),
        TextSpan(
            text: phrase, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]);
}

class SentenceSummary extends StatelessWidget {
  const SentenceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListOfRecurringDeltas>(builder: (context, value, child) {
      return FutureBuilder<TextSpan>(
          future: _sentenceSummaryDynamicGenerator(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: mainTheme.colorScheme.primary,
              ));
            }

            return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("assets/navbar/navbarbg.png"),
                        fit: BoxFit.fill),
                    color: mainTheme.colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: mainTheme.colorScheme.surface.withOpacity(0.5),
                        offset: const Offset(5, 10),
                        blurRadius: 20,
                      )
                    ]),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: snapshot.data!,
                ));
          });
    });
  }
}
