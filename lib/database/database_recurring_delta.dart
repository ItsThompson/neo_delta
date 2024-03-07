import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/models/delta_progress.dart';
import 'package:neo_delta/models/recurring_delta.dart';

class DatabaseRecurringDeltaService {
  static final DatabaseService _databaseService = DatabaseService();

  // Future<RecurringDelta> getRecurringDeltaById(int id) async {
  //   final db = await _databaseService.db;
  //   var data =
  //       await db.query("recurring_delta", where: "id = ?", whereArgs: [id]);
  //   var out = [
  //     for (final {
  //           'id': id as int,
  //           'name': name as String,
  //           'icon_src': iconSrc as String,
  //           'interval': deltaInterval as String,
  //           'weighting': weighting as int,
  //           'minimum_volume': minimumVolume as int,
  //           'effective_volume': effectiveVolume as int,
  //           'optimal_volume': optimalVolume as int,
  //           'start_date': startDate as String,
  //         } in data)
  //       RecurringDelta(
  //         id: id,
  //         name: name,
  //         iconSrc: iconSrc,
  //         deltaInterval: parseStringToDeltaInterval(deltaInterval),
  //         weighting: weighting,
  //         remainingFrequency: calculateRemainingFrequencyForRecurringDelta(id),
  //         minimumVolume: minimumVolume,
  //         effectiveVolume: effectiveVolume,
  //         optimalVolume: optimalVolume,
  //         startDate: DateTime.parse(startDate),
  //         completedToday: recurringDeltaIsCompleted(id),
  //       ),
  //   ];
  //   return out[0];
  // }

  Future<String> getRecurringDeltaNameById(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['name'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'name': name as String,
          } in data)
        name,
    ];
    return out[0];
  }

  Future<DeltaInterval> getRecurringDeltaIntervalById(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['interval'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'interval': interval as String,
          } in data)
        parseStringToDeltaInterval(interval),
    ];
    return out[0];
  }

  Future<int> getMinimumVolumeFromId(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['minimum_volume'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'minimum_volume': minimumVolume as int,
          } in data)
        minimumVolume
    ];
    return out[0];
  }

  Future<int> getEffectiveVolumeFromId(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['effective_volume'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'effective_volume': effectiveVolume as int,
          } in data)
        effectiveVolume
    ];
    return out[0];
  }

  Future<int> getOptimalVolumeFromId(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['optimal_volume'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'optimal_volume': optimalVolume as int,
          } in data)
        optimalVolume
    ];
    return out[0];
  }

  Future<int> getWeightingFromId(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['weighting'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'weighting': weighting as int,
          } in data)
        weighting
    ];
    return out[0];
  }

  Future<DateTime> getStartDateFromId(int id) async {
    final db = await _databaseService.db;
    var data = await db.query("recurring_delta",
        columns: ['startDate'], where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'start_date': startDate as String,
          } in data)
        DateTime.parse(startDate),
    ];
    return out[0];
  }

  Future<void> insertNewCompletion(int deltaId) async {
    final db = await _databaseService.db;
    var now = DateTime.now();
    await db.rawInsert(
      "INSERT INTO delta_progress (delta_id, completed_at)",
      [deltaId, now.toIso8601String()],
    );
  }

  Future<void> deleteMostRecentCompletion(int deltaId) async {
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

    // List: New -> Old
    list.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    DeltaProgress removedItem = list[0];

    await db
        .delete("delta_progress", where: 'id = ?', whereArgs: [removedItem.id]);
  }
}
