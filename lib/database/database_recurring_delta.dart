import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/models/delta_progress.dart';
import 'package:neo_delta/models/recurring_delta.dart';
import 'package:provider/provider.dart';

class DatabaseRecurringDeltaService {
  static final DatabaseService _databaseService = DatabaseService();

  Future<List<RecurringDelta>> getAllRecurringDeltas(
      BuildContext context) async {
    List<RecurringDelta> providerRecurringDeltaList =
        context.read<ListOfRecurringDeltas>().recurringDeltaList;

    if (providerRecurringDeltaList.isNotEmpty) {
      return providerRecurringDeltaList;
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta");
    var out = [
      for (final {
            'id': id as int,
            'name': name as String,
            'icon_src': iconSrc as String,
            'interval': deltaInterval as String,
            'weighting': weighting as int,
            'minimum_volume': minimumVolume as int,
            'effective_volume': effectiveVolume as int,
            'optimal_volume': optimalVolume as int,
            'start_date': startDate as String,
          } in data)
        RecurringDelta(
          id: id,
          name: name,
          iconSrc: iconSrc,
          deltaInterval: parseStringToDeltaInterval(deltaInterval),
          weighting: weighting,
          remainingVolume: await calculateRemainingVolumeForRecurringDelta(id),
          minimumVolume: minimumVolume,
          effectiveVolume: effectiveVolume,
          optimalVolume: optimalVolume,
          startDate: DateTime.parse(startDate),
          completedToday: await recurringDeltaOptimalVolumeReached(id),
        ),
    ];

    if (context.mounted) {
      context.read<ListOfRecurringDeltas>().recurringDeltaList = out;
    }

    return out;
  }

  Future<RecurringDelta> getRecurringDeltaById(
      int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db
        .query("recurring_delta", where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'id': id as int,
            'name': name as String,
            'icon_src': iconSrc as String,
            'interval': deltaInterval as String,
            'weighting': weighting as int,
            'minimum_volume': minimumVolume as int,
            'effective_volume': effectiveVolume as int,
            'optimal_volume': optimalVolume as int,
            'start_date': startDate as String,
          } in data)
        RecurringDelta(
          id: id,
          name: name,
          iconSrc: iconSrc,
          deltaInterval: parseStringToDeltaInterval(deltaInterval),
          weighting: weighting,
          remainingVolume:
              await calculateRemainingVolumeForRecurringDelta(deltaId),
          minimumVolume: minimumVolume,
          effectiveVolume: effectiveVolume,
          optimalVolume: optimalVolume,
          startDate: DateTime.parse(startDate),
          completedToday: await recurringDeltaOptimalVolumeReached(deltaId),
        ),
    ];
    return out[0];
  }

  Future<DeltaInterval> getRecurringDeltaIntervalById(
      int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta.deltaInterval;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['interval'], where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'interval': interval as String,
          } in data)
        parseStringToDeltaInterval(interval),
    ];
    return out[0];
  }

  Future<int> getMinimumVolumeFromId(int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta.minimumVolume;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['minimum_volume'], where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'minimum_volume': minimumVolume as int,
          } in data)
        minimumVolume
    ];
    return out[0];
  }

  Future<int> getEffectiveVolumeFromId(
      int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta.effectiveVolume;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['effective_volume'], where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'effective_volume': effectiveVolume as int,
          } in data)
        effectiveVolume
    ];
    return out[0];
  }

  Future<int> getOptimalVolumeFromId(int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta.optimalVolume;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['optimal_volume'], where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'optimal_volume': optimalVolume as int,
          } in data)
        optimalVolume
    ];
    return out[0];
  }

  Future<int> getWeightingFromId(int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta.weighting;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['weighting'], where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'weighting': weighting as int,
          } in data)
        weighting
    ];
    return out[0];
  }

  Future<DateTime> getStartDateFromId(
      int deltaId, BuildContext? context) async {
    if (context != null) {
      List<RecurringDelta> providerRecurringDeltaList =
          context.read<ListOfRecurringDeltas>().recurringDeltaList;

      if (providerRecurringDeltaList.isNotEmpty) {
        for (var recurringDelta in providerRecurringDeltaList) {
          if (recurringDelta.id == deltaId) {
            return recurringDelta.startDate;
          }
        }
      }
    }

    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['start_date'], where: "id = ?", whereArgs: [deltaId]);
    var out = [
      for (final {
            'start_date': startDate as String,
          } in data)
        DateTime.parse(startDate),
    ];
    return out[0];
  }

  Future<void> insertNewCompletion(int deltaId, BuildContext context) async {
    final db = await _databaseService.db;
    var now = DateTime.now();
    await db.rawInsert(
      "INSERT INTO delta_progress (delta_id, completed_at) VALUES (?,?)",
      [deltaId, now.toIso8601String()],
    );

    if (context.mounted) {
      context.read<ListOfRecurringDeltas>().decrementVolume(deltaId);
    }
  }

  Future<void> deleteMostRecentCompletion(
      int deltaId, BuildContext context) async {
    final db = await _databaseService.db;
    final list = await getDeltaProgressSortedByRecentToOld(deltaId);

    DeltaProgress removedItem = list[0]; // Takes most recent progress item

    await db
        .delete("delta_progress", where: 'id = ?', whereArgs: [removedItem.id]);

    if (context.mounted) {
      context.read<ListOfRecurringDeltas>().incrementVolume(deltaId);
    }
  }

  Future<bool> isCompletedToday(int deltaId) async {
    final list = await getDeltaProgressSortedByRecentToOld(deltaId);

    final now = DateTime.now();

    for (var deltaProgress in list) {
      DateTime deltaProgressCompletedAt = deltaProgress.completedAt;
      if (DateUtils.isSameDay(deltaProgressCompletedAt, now)) {
        return true;
      }
    }
    return false;
  }

  // List: New -> Old
  Future<List<DeltaProgress>> getDeltaProgressSortedByRecentToOld(
      int deltaId) async {
    final db = await _databaseService.db;

    // Selects all where deltaId
    var data = await db.query("delta_progress",
        columns: ['id', 'completed_at'],
        where: "delta_id = ?",
        whereArgs: [deltaId]);
    var list = [
      for (final {'id': id as int, 'completed_at': completedAt as String}
          in data)
        DeltaProgress(
            id: id, deltaId: deltaId, completedAt: DateTime.parse(completedAt)),
    ];

    list.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return list;
  }

  Future<int> getVolumeForToday(int deltaId) async {
    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(deltaId);

    DateTime now = DateTime.now();
    DateTime todayDate = DateTime(now.year, now.month, now.day);

    int count = 0;
    for (final deltaProgress in list) {
      DateTime dateOfDeltaProgressCompletion = DateTime(
          deltaProgress.completedAt.year,
          deltaProgress.completedAt.month,
          deltaProgress.completedAt.day);
      if (dateOfDeltaProgressCompletion.isAtSameMomentAs(todayDate)) {
        count += 1;
      }
    }

    return count;
  }

  Future<int> getVolumeInIntervalWithStartDate(
      int deltaId, DateTime startDate, BuildContext? context) async {
    final DeltaInterval interval =
        await getRecurringDeltaIntervalById(deltaId, context);
    final DateTime endOfIntervalDate = endOfDeltaInterval(interval, startDate);

    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(deltaId);

    int count = 0;

    for (final deltaProgress in list) {
      // startDate <= deltaProgress.completedAt <= endOfIntervalDate
      if ((startDate.isBefore(deltaProgress.completedAt) ||
              startDate.isAtSameMomentAs(deltaProgress.completedAt)) &&
          (endOfIntervalDate.isAfter(deltaProgress.completedAt) ||
              endOfIntervalDate.isAtSameMomentAs(deltaProgress.completedAt))) {
        count += 1;
      }
    }

    return count;
  }

  Future<int> getVolumeForCurrentInterval(int deltaId) async {
    final DeltaInterval interval =
        await getRecurringDeltaIntervalById(deltaId, null);
    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(deltaId);
    final DateTime cutOffDate = endOfCurrentInterval(interval);

    int count = 0;
    for (final deltaProgress in list) {
      if (cutOffDate.isBefore(deltaProgress.completedAt)) {
        count += 1;
      }
    }

    return count;
  }

  Future<int> calculateRemainingVolumeForRecurringDelta(int deltaId) async {
    final int optimalVolume = await getOptimalVolumeFromId(deltaId, null);
    final int count = await getVolumeForCurrentInterval(deltaId);

    return optimalVolume - count;
  }

  Future<bool> recurringDeltaOptimalVolumeReached(int deltaId) async {
    // Optimal Volume is Reached
    final int optimalVolume = await getOptimalVolumeFromId(deltaId, null);
    final int count = await getVolumeForCurrentInterval(deltaId);

    if (count >= optimalVolume) {
      return true;
    }
    return false;
  }

  Future<Map<DateTime, int>> getRecurringDeltaIntervalCountHashMap(
      RecurringDelta recurringDelta) async {
    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(recurringDelta.id);

    Map<DateTime, int> intervalCount = HashMap<DateTime, int>();
    // Key: Starting DateTime Interval,
    // Value: Count

    for (final deltaProgress in list) {
      DateTime beginning = startOfDeltaInterval(
          recurringDelta.deltaInterval, deltaProgress.completedAt);
      intervalCount.update(beginning, (value) => ++value, ifAbsent: () => 1);
    }

    return intervalCount;
  }

  Future<Map<DateTime, int>> getRecurringDeltaIntervalCountSplayTreeMap(
      RecurringDelta recurringDelta) async {
    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(recurringDelta.id);

    SplayTreeMap<DateTime, int> intervalCount = SplayTreeMap<DateTime, int>();
    // Key: Starting DateTime Interval,
    // Value: Count
    // SplayTreeMap -> Keys are sorted (Ascending)

    for (final deltaProgress in list) {
      DateTime beginning = startOfDeltaInterval(
          recurringDelta.deltaInterval, deltaProgress.completedAt);
      intervalCount.update(beginning, (value) => ++value, ifAbsent: () => 1);
    }

    return intervalCount;
  }

  Future<double> getRecurringDeltaSuccessRateFromRecurringDelta(
      RecurringDelta recurringDelta) async {
    Map<DateTime, int> intervalCount =
        await getRecurringDeltaIntervalCountHashMap(recurringDelta);

    int isCompleted = 0;

    for (final v in intervalCount.values) {
      if (v >= recurringDelta.optimalVolume) {
        isCompleted += 1;
      }
    }

    if (intervalCount.isEmpty) {
      return 0;
    }

    return (isCompleted / intervalCount.values.length) * 100;
  }

  Future<int> getLongestStreakFromRecurringDelta(
      RecurringDelta recurringDelta) async {
    Map<DateTime, int> intervalCount =
        await getRecurringDeltaIntervalCountSplayTreeMap(recurringDelta);

    int longestStreak = 0;
    int currentStreak = 0;

    for (final v in intervalCount.values) {
      if (v >= recurringDelta.optimalVolume) {
        // Completed in Interval
        currentStreak += 1;

        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }

    return longestStreak;
  }

  Future<double> getAllTimeDeltaPercentageFromRecurringDelta(
      RecurringDelta recurringDelta) async {
    final int minimumVolume = recurringDelta.minimumVolume;
    final int effectiveVolume = recurringDelta.effectiveVolume;
    final int optimalVolume = recurringDelta.optimalVolume;
    final DeltaInterval interval = recurringDelta.deltaInterval;
    final DateTime startDate = recurringDelta.startDate;
    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(recurringDelta.id);

    SplayTreeMap<DateTime, int> intervalCount = SplayTreeMap<DateTime, int>();
    // Key: Starting DateTime Interval,
    // Value: Count
    // SplayTreeMap -> Keys are sorted (Ascending)

    for (final deltaProgress in list) {
      DateTime beginning =
          startOfDeltaInterval(interval, deltaProgress.completedAt);
      intervalCount.update(beginning, (value) => ++value, ifAbsent: () => 1);
    }

    // List of every startOfInterval since startDate til today.
    List<DateTime> listOfStartOfIntervalDateTimes =
        deltaIntervalStartDateFromDate(interval, startDate);

    double allTimeDelta = 0;

    for (final start in listOfStartOfIntervalDateTimes) {
      if (intervalCount.containsKey(start)) {
        double delta = calculateDelta(intervalCount[start]!, minimumVolume,
            effectiveVolume, optimalVolume);
        allTimeDelta += delta;
      } else {
        allTimeDelta -= 1;
      }
    }
    return allTimeDelta * 100; // Percentage
  }

  Future<double> getThisMonthDeltaPercentageFromRecurringDelta(
      RecurringDelta recurringDelta) async {
    final List<DeltaProgress> list =
        await getDeltaProgressSortedByRecentToOld(recurringDelta.id);

    SplayTreeMap<DateTime, int> intervalCount = SplayTreeMap<DateTime, int>();
    // Key: Starting DateTime Interval,
    // Value: Count
    // SplayTreeMap -> Keys are sorted (Ascending)

    for (final deltaProgress in list) {
      DateTime beginning = startOfDeltaInterval(
          recurringDelta.deltaInterval, deltaProgress.completedAt);
      intervalCount.update(beginning, (value) => ++value, ifAbsent: () => 1);
    }

    // List of every startOfInterval since startDate til today.
    DateTime now = DateTime.now();
    List<DateTime> listOfStartOfIntervalDateTimes =
        deltaIntervalStartDateFromDate(
            recurringDelta.deltaInterval, DateTime(now.year, now.month, 1));

    double allTimeDelta = 0;

    for (final start in listOfStartOfIntervalDateTimes) {
      if (intervalCount.containsKey(start)) {
        double delta = calculateDelta(
            intervalCount[start]!,
            recurringDelta.minimumVolume,
            recurringDelta.effectiveVolume,
            recurringDelta.optimalVolume);
        allTimeDelta += delta;
      } else {
        allTimeDelta -= 1;
      }
    }
    return allTimeDelta * 100; // Percentage
  }

  Future<void> insertNewRecurringDelta(RecurringDelta recurringDelta) async {
    final db = await _databaseService.db;
    await db.rawInsert(
        "INSERT INTO recurring_delta (name, icon_src, interval, weighting, minimum_volume, effective_volume, optimal_volume, start_date) VALUES (?,?,?,?,?,?,?,?)",
        [
          recurringDelta.name,
          recurringDelta.iconSrc,
          recurringDelta.deltaInterval.toString(),
          recurringDelta.weighting,
          recurringDelta.minimumVolume,
          recurringDelta.effectiveVolume,
          recurringDelta.optimalVolume,
          recurringDelta.startDate.toString(),
        ]);
  }
}
