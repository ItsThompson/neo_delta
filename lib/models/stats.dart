import 'dart:math';
import 'dart:collection';

import 'package:flutter/material.dart';
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

      double dayDelta = 0;

      // Landmark Deltas
      // TODO: Maybe some sort of yellow border around day (For Month and Week View)

      // Check if landmarkDeltasInCurrentMonth is in current month and current year
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
      for (var landmarkDelta in landmarkDeltasInCurrentMonth) {
        if (landmarkDelta.dateTime.day == currentIterationDate.day) {
          dayDelta += landmarkDelta.weighting;
        }
      }

      // Recurring Deltas
      for (var recurringDeltaId in recurringDeltaIds) {
        RecurringDelta recurringDelta = await DatabaseRecurringDeltaService()
            .getRecurringDeltaById(
                recurringDeltaId, context.mounted == true ? context : null);
        int volume = await DatabaseRecurringDeltaService()
            .getVolumeInIntervalWithStartDate(recurringDeltaId, startDate,
                context.mounted == true ? context : null); 


        // currentDate > endOfDeltaIntervalDate
        if (currentIterationDate.isAfter(endOfDeltaInterval(
            recurringDelta.deltaInterval, currentIterationDate))) {
          double delta = calculateDelta(volume, recurringDelta.minimumVolume,
              recurringDelta.effectiveVolume, recurringDelta.optimalVolume);
          dayDelta += (delta / volume) * recurringDelta.weighting;
        }
      }

      progress.add((currentIterationDate, dayDelta));
      currentIterationDate = currentIterationDate.add(const Duration(days: 1));
    }

    return StatsData(progress: progress);
  }

  //TODO: Generate All time Stats Data (Monthly)
  static Future<StatsData> generateAllTimeStatsData(
      List<int> recurringDeltaIds, DateTime startDate) async {
    // All Time Stats View
    List<(DateTime, double)> progress = [];

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
