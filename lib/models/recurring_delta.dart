import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:neo_delta/database/database_recurring_delta.dart';

enum DeltaInterval { day, week, month }

// NOTE: smart icon selection (tag system?)
class RecurringDelta {
  final int id;
  final String name;
  final String iconSrc;
  final DeltaInterval deltaInterval;
  final int weighting;
  final int remainingVolume; // Remaining Volume until Optimal Volume
  final int minimumVolume;
  final int effectiveVolume;
  final int optimalVolume;
  final DateTime startDate;
  final bool completedToday;
  RecurringDelta(
      {required this.id,
      required this.name,
      required this.iconSrc,
      required this.deltaInterval,
      required this.weighting,
      required this.remainingVolume,
      required this.minimumVolume,
      required this.effectiveVolume,
      required this.optimalVolume,
      required this.startDate,
      required this.completedToday});
}

String deltaIntervalCurrentString(DeltaInterval interval) {
  switch (interval) {
    case DeltaInterval.day:
      return "TODAY";
    case DeltaInterval.week:
      return "THIS WEEK";
    case DeltaInterval.month:
      return "THIS MONTH";
  }
}

String deltaIntervalAdverbString(DeltaInterval interval) {
  switch (interval) {
    case DeltaInterval.day:
      return "DAILY";
    case DeltaInterval.week:
      return "WEEKLY";
    case DeltaInterval.month:
      return "MONTHLY";
  }
}

String deltaIntervalPeriodString(DeltaInterval interval) {
  switch (interval) {
    case DeltaInterval.day:
      return "DAY";
    case DeltaInterval.week:
      return "WEEK";
    case DeltaInterval.month:
      return "MONTH";
  }
}

DeltaInterval parseStringToDeltaInterval(String deltaIntervalString) {
  // deltaIntervalString is taken from DB
  switch (deltaIntervalString) {
    case "DeltaInterval.day":
      return DeltaInterval.day;
    case "DeltaInterval.week":
      return DeltaInterval.week;
    case "DeltaInterval.month":
      return DeltaInterval.month;
    default:
      return DeltaInterval.day; // Default
  }
}

DateTime endOfCurrentInterval(DeltaInterval interval) {
  DateTime now = DateTime.now();

  return startOfDeltaInterval(interval, now);
}

DateTime endOfDeltaInterval(DeltaInterval interval, DateTime dateTime) {
  switch (interval) {
    case DeltaInterval.day:
      return DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
          .subtract(const Duration(seconds: 1));
    case DeltaInterval.week:
      DateTime monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      DateTime startOfMonday = DateTime(monday.year, monday.month, monday.day);
      return startOfMonday
          .add(const Duration(days: 7))
          .subtract(const Duration(seconds: 1));
    case DeltaInterval.month:
      DateTime beginningOfFirstDayOfMonth =
          DateTime(dateTime.year, dateTime.month, 1);
      return DateTime(
              beginningOfFirstDayOfMonth.year,
              beginningOfFirstDayOfMonth.month + 1,
              beginningOfFirstDayOfMonth.day)
          .subtract(const Duration(seconds: 1));
  }
}

DateTime startOfCurrentInterval(DeltaInterval interval) {
  DateTime now = DateTime.now();

  return startOfDeltaInterval(interval, now);
}

DateTime startOfDeltaInterval(DeltaInterval interval, DateTime dateTime) {
  switch (interval) {
    case DeltaInterval.day:
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    case DeltaInterval.week:
      DateTime monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      return DateTime(monday.year, monday.month, monday.day);
    case DeltaInterval.month:
      return DateTime(dateTime.year, dateTime.month, 1);
  }
}

List<DateTime> deltaIntervalStartDateFromDate(
    DeltaInterval interval, DateTime date) {
  // Get the start DateTime of each DeltaInterval from date til now.
  List<DateTime> list = [];
  DateTime now = DateTime.now();

  DateTime nextDate = startOfDeltaInterval(interval, date);

  if (interval == DeltaInterval.month) {
    // while nextDate <= endDate
    while (nextDate.isBefore(now) ||
        nextDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      list.add(nextDate);
      nextDate = DateTime(nextDate.year, nextDate.month + 1, 1);
    }
    return list;
  }

  Duration addDuration = const Duration(days: 1);

  switch (interval) {
    case DeltaInterval.day:
      addDuration = const Duration(days: 1);
    case DeltaInterval.week:
      addDuration = const Duration(days: 7);
    default:
      break;
  }

  // while nextDate <= endDate
  while (nextDate.isBefore(now) ||
      nextDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
    list.add(nextDate);
    nextDate = nextDate.add(addDuration);
  }
  return list;
}

(DateTime, DateTime) rangeOfDeltaInterval(DeltaInterval interval, DateTime dateTime) {
  switch (interval) {
    case DeltaInterval.day:
      DateTime startOfDay =
          DateTime(dateTime.year, dateTime.month, dateTime.day);
      DateTime endOfDay =
          DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
              .subtract(const Duration(seconds: 1));
      return (startOfDay, endOfDay);
    case DeltaInterval.week:
      DateTime monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      DateTime startOfMonday = DateTime(monday.year, monday.month, monday.day);
      DateTime endOfSunday = startOfMonday
          .add(const Duration(days: 7))
          .subtract(const Duration(seconds: 1));
      return (startOfMonday, endOfSunday);
    case DeltaInterval.month:
      DateTime beginningOfFirstDayOfMonth =
          DateTime(dateTime.year, dateTime.month, 1);
      DateTime endOfLastDayOfMonth = DateTime(
              beginningOfFirstDayOfMonth.year,
              beginningOfFirstDayOfMonth.month + 1,
              beginningOfFirstDayOfMonth.day)
          .subtract(const Duration(seconds: 1));
      return (beginningOfFirstDayOfMonth, endOfLastDayOfMonth);
  }
}

class ListOfRecurringDeltas extends ChangeNotifier {
  List<RecurringDelta> _recurringDeltaList = [];

  UnmodifiableListView<RecurringDelta> get recurringDeltaList =>
      UnmodifiableListView(_recurringDeltaList);

  set recurringDeltaList(List<RecurringDelta> newRecurringDeltaList) {
    _recurringDeltaList = newRecurringDeltaList;
    notifyListeners();
  }

  RecurringDelta? getRecurringDelta(int deltaId) {
    for (var recurringDelta in recurringDeltaList) {
      if (recurringDelta.id == deltaId) {
        return recurringDelta;
      }
    }
    return null;
  }

  void addToList(RecurringDelta newRecurringDelta) {
    _recurringDeltaList.add(newRecurringDelta);
    notifyListeners();
  }

  void incrementVolume(int deltaId) async {
    for (var i = 0; i < _recurringDeltaList.length; i++) {
      if (_recurringDeltaList[i].id == deltaId) {
        RecurringDelta newRecurringDelta = RecurringDelta(
            id: _recurringDeltaList[i].id,
            name: _recurringDeltaList[i].name,
            iconSrc: _recurringDeltaList[i].iconSrc,
            deltaInterval: _recurringDeltaList[i].deltaInterval,
            weighting: _recurringDeltaList[i].weighting,
            remainingVolume: _recurringDeltaList[i].remainingVolume + 1,
            minimumVolume: _recurringDeltaList[i].minimumVolume,
            effectiveVolume: _recurringDeltaList[i].effectiveVolume,
            optimalVolume: _recurringDeltaList[i].optimalVolume,
            startDate: _recurringDeltaList[i].startDate,
            completedToday: await DatabaseRecurringDeltaService()
                .isCompletedToday(deltaId));
        _recurringDeltaList[i] = newRecurringDelta;
      }
    }
    notifyListeners();
  }

  void decrementVolume(int deltaId) async {
    for (var i = 0; i < _recurringDeltaList.length; i++) {
      if (_recurringDeltaList[i].id == deltaId) {
        RecurringDelta newRecurringDelta = RecurringDelta(
            id: _recurringDeltaList[i].id,
            name: _recurringDeltaList[i].name,
            iconSrc: _recurringDeltaList[i].iconSrc,
            deltaInterval: _recurringDeltaList[i].deltaInterval,
            weighting: _recurringDeltaList[i].weighting,
            remainingVolume: _recurringDeltaList[i].remainingVolume - 1,
            minimumVolume: _recurringDeltaList[i].minimumVolume,
            effectiveVolume: _recurringDeltaList[i].effectiveVolume,
            optimalVolume: _recurringDeltaList[i].optimalVolume,
            startDate: _recurringDeltaList[i].startDate,
            completedToday: await DatabaseRecurringDeltaService()
                .isCompletedToday(deltaId));
        _recurringDeltaList[i] = newRecurringDelta;
      }
    }
    notifyListeners();
  }
}
