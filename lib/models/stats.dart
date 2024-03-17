import 'dart:js_interop';
import 'dart:math';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/database/database_landmark_delta.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';
import 'package:neo_delta/models/delta_progress.dart';
import 'package:neo_delta/models/landmark_delta.dart';
import 'package:neo_delta/models/recurring_delta.dart';

enum StatsPageView { week, month, allTime }

String getPageViewString(StatsPageView pageView) {
  switch (pageView) {
    case StatsPageView.week:
      return "THIS WEEK";
    case StatsPageView.month:
      return "THIS MONTH";
    case StatsPageView.allTime:
      return "ALL TIME";
  }
}

class StatsFilter extends ChangeNotifier {
  List<StatsFilterItem> _filterList = [
    StatsFilterItem(name: "ALL TASKS", included: false),
    StatsFilterItem(name: "DELTA 1", included: true),
    StatsFilterItem(name: "DELTA 2", included: false),
    StatsFilterItem(name: "DELTA 3", included: false),
    StatsFilterItem(name: "DELTA 4", included: true),
    StatsFilterItem(name: "DELTA 5", included: false),
    StatsFilterItem(name: "DELTA 6", included: true),
  ];

  // An unmodifiable view of the items.
  UnmodifiableListView<StatsFilterItem> get filterList =>
      UnmodifiableListView(_filterList);

  set filterList(List<StatsFilterItem> filterList) {
    _filterList = filterList;
    notifyListeners();
  }

  bool shouldUpdateStats = false;
}

class StatsFilterItem {
  final String name;
  bool included;

  StatsFilterItem({required this.name, required this.included});
}

class StatsPageViewIndex extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  int _length = 0;

  int get length => _length;

  set length(int newLength) {
    _length = newLength;
    notifyListeners();
  }
}

class StatsData {
  final List<(DateTime, double)> progress;

  bool hasNegativeValues() {
    for (var i = 0; i < progress.length; i++) {
      if (progress[i].$2 < 0) {
        return true;
      }
    }
    return false;
  }

  (double, double) getMinMax() {
    double maximum = progress[0].$2;
    double minimum = progress[0].$2;
    for (var i = 1; i < progress.length; i++) {
      if (progress[i].$2 > maximum) {
        maximum = progress[i].$2;
      }
      if (progress[i].$2 < minimum) {
        minimum = progress[i].$2;
      }
    }

    if (hasNegativeValues()) {
      double range = max(maximum.abs(), minimum.abs());
      return (-range, range);
    }
    return (0, maximum);
  }

  static Future<StatsData> generateWeekStatsData(
      List<int> recurringDeltaIds, BuildContext context) async {
    DateTime startOfWeek = startOfCurrentInterval(DeltaInterval.week);

    return StatsData._generateDailyStatsDataFromDate(
        recurringDeltaIds, startOfWeek, DateTime.now(), context);
  }

  static Future<StatsData> generateMonthStatsData(
      List<int> recurringDeltaIds, BuildContext context) async {
    DateTime startOfMonth = startOfCurrentInterval(DeltaInterval.month);

    return StatsData._generateDailyStatsDataFromDate(
        recurringDeltaIds, startOfMonth, DateTime.now(), context);
  }

  static Future<StatsData> _generateDailyStatsDataFromDate(
      List<int> recurringDeltaIds,
      DateTime startDate,
      DateTime endDate,
      BuildContext context) async {
    // Month and Week Stats View
    List<(DateTime, double)> progress = [];

    DateTime currentIterationDate = startDate;

    List<LandmarkDelta> landmarkDeltasInCurrentMonth =
        await DatabaseLandmarkDeltaService()
            .getAllLandmarkDeltasWithYearAndMonth(
                startDate.year, startDate.month);
    // while nextDate <= endDate
    while (currentIterationDate.isBefore(endDate) ||
        currentIterationDate.isAtSameMomentAs(
            DateTime(endDate.year, endDate.month, endDate.day))) {
      // Numerous RecurringDeltas everyday and potential LandmarkDeltas
      // RecurringDeltas may not have change every day.

      double dailyWeightedDelta = 0;

      Map<int, RecurringDelta> recurringDeltas = {};

      // Check if landmarkDeltasInCurrentMonth is in current month and current year
      // Updates landmarkDeltasInCurrentMonth if not (Every first of month)
      if (landmarkDeltasInCurrentMonth.isNotEmpty) {
        DateTime dateTimeOfFirstLandmarkDelta =
            landmarkDeltasInCurrentMonth[0].dateTime;
        if ((dateTimeOfFirstLandmarkDelta.year != currentIterationDate.year) ||
            (dateTimeOfFirstLandmarkDelta.month !=
                currentIterationDate.month)) {
          landmarkDeltasInCurrentMonth = await DatabaseLandmarkDeltaService()
              .getAllLandmarkDeltasWithYearAndMonth(
                  startDate.year, startDate.month);
        }
      }

      // Landmark Deltas
      // TODO: Maybe some sort of yellow border around day (For Month and Week View)
      for (var landmarkDelta in landmarkDeltasInCurrentMonth) {
        if (landmarkDelta.dateTime.day == currentIterationDate.day) {
          dailyWeightedDelta += landmarkDelta.weighting;
        }
      }

      // Recurring Deltas
      for (var recurringDeltaId in recurringDeltaIds) {
        RecurringDelta recurringDelta;

        if (recurringDeltas[recurringDeltaId] == null) {
          recurringDelta = await DatabaseRecurringDeltaService()
              .getRecurringDeltaById(
                  recurringDeltaId, context.mounted == true ? context : null);
        } else {
          recurringDelta = recurringDeltas[recurringDeltaId]!;
        }

        int volumeInInterval = await DatabaseRecurringDeltaService()
            .getVolumeInIntervalWithStartDate(recurringDeltaId, startDate,
                context.mounted == true ? context : null);

        double delta = calculateDelta(
            volumeInInterval,
            recurringDelta.minimumVolume,
            recurringDelta.effectiveVolume,
            recurringDelta.optimalVolume);

        dailyWeightedDelta +=
            (delta / volumeInInterval) * recurringDelta.weighting;
      }

      progress.add((currentIterationDate, dailyWeightedDelta));
      currentIterationDate = currentIterationDate.add(const Duration(days: 1));
    }

    return StatsData(progress: progress);
  }

  static Future<StatsData> generateAllTimeStatsData(List<int> recurringDeltaIds,
      BuildContext context) async {
    // All Time Stats View
    List<(DateTime, double)> progress = []; // (Month, Weighted Delta)

    DateTime startDate = await DatabaseService().getFirstDeltaEntryDate();

    DateTime currentIterationDate = startDate;
    DateTime now = DateTime.now();
    DateTime endDate = DateTime(now.year, now.month, now.day);

    List<LandmarkDelta> landmarkDeltasInCurrentMonth =
        await DatabaseLandmarkDeltaService()
            .getAllLandmarkDeltasWithYearAndMonth(
                startDate.year, startDate.month);

    double monthlyWeightedDelta = 0;

    Map<int, RecurringDelta> recurringDeltas = {};

    // while nextDate <= endDate
    while (currentIterationDate.isBefore(endDate) ||
        currentIterationDate.isAtSameMomentAs(
            DateTime(endDate.year, endDate.month, endDate.day))) {
      double dailyWeightedDelta = 0;

      if (landmarkDeltasInCurrentMonth.isNotEmpty) {
        DateTime dateTimeOfFirstLandmarkDelta =
            landmarkDeltasInCurrentMonth[0].dateTime;
        if ((dateTimeOfFirstLandmarkDelta.year != currentIterationDate.year) ||
            (dateTimeOfFirstLandmarkDelta.month !=
                currentIterationDate.month)) {
          landmarkDeltasInCurrentMonth = await DatabaseLandmarkDeltaService()
              .getAllLandmarkDeltasWithYearAndMonth(
                  startDate.year, startDate.month);
        }
      }

      // Landmark Deltas
      for (var landmarkDelta in landmarkDeltasInCurrentMonth) {
        if (landmarkDelta.dateTime.day == currentIterationDate.day) {
          dailyWeightedDelta += landmarkDelta.weighting;
        }
      }

      // Recurring Deltas
      for (var recurringDeltaId in recurringDeltaIds) {
        RecurringDelta recurringDelta;

        if (recurringDeltas[recurringDeltaId] == null) {
          recurringDelta = await DatabaseRecurringDeltaService()
              .getRecurringDeltaById(
                  recurringDeltaId, context.mounted == true ? context : null);
        } else {
          recurringDelta = recurringDeltas[recurringDeltaId]!;
        }

        int volumeInInterval = await DatabaseRecurringDeltaService()
            .getVolumeInIntervalWithStartDate(recurringDeltaId, startDate,
                context.mounted == true ? context : null);

        double delta = calculateDelta(
            volumeInInterval,
            recurringDelta.minimumVolume,
            recurringDelta.effectiveVolume,
            recurringDelta.optimalVolume);

        dailyWeightedDelta +=
            (delta / volumeInInterval) * recurringDelta.weighting;
      }

      if (currentIterationDate ==
          DateTime(currentIterationDate.year, currentIterationDate.month, 1)) {
        // current is start of the month
        progress.add((currentIterationDate, monthlyWeightedDelta));
        // Add all of this month into progress
        monthlyWeightedDelta = dailyWeightedDelta;
        // Reset "monthlyWeightedDelta"
      } else {
        monthlyWeightedDelta += dailyWeightedDelta;
        // Adds to "monthlyWeightedDelta"
      }
      currentIterationDate = currentIterationDate.add(const Duration(days: 1));
    }

    return StatsData(progress: progress);
  }

  factory StatsData.generateFakeData(int length, int maximum, int minimum) {
    List<(DateTime, double)> progress = [];
    Random random = Random();
    double randomNumber;
    DateTime dateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    for (var i = 0; i < length; i++) {
      randomNumber = double.parse(
          (minimum + random.nextDouble() * (maximum - minimum))
              .toStringAsFixed(2));
      progress.add((dateTime, randomNumber));
      dateTime = dateTime.add(const Duration(days: 1));
    }
    return StatsData(progress: progress);
  }

  StatsData({required this.progress});
}
