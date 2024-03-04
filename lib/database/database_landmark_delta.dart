import 'package:neo_delta/database/database.dart';
import 'package:neo_delta/models/landmark_delta.dart';

class DatabaseLandmarkDeltaService {
  static final DatabaseService _databaseService = DatabaseService();

  Future<List<LandmarkDelta>> getAllLandmarkDeltas() async {
    final db = await _databaseService.db;
    var data = await db.query("landmark_delta");

    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'date_time': dateTime as String,
            'weighting': weighting as int,
            'description': description as String,
          } in data)
        LandmarkDelta(
            id: id,
            name: name,
            dateTime: DateTime.parse(dateTime),
            weighting: weighting,
            description: description),
    ];
  }

  Future<LandmarkDelta> getLandmarkDeltaById(int id) async {
    final db = await _databaseService.db;
    var data =
        await db.query("landmark_delta", where: "id = ?", whereArgs: [id]);
    var out = [
      for (final {
            'id': id as int,
            'name': name as String,
            'date_time': dateTime as String,
            'weighting': weighting as int,
            'description': description as String,
          } in data)
        LandmarkDelta(
            id: id,
            name: name,
            dateTime: DateTime.parse(dateTime),
            weighting: weighting,
            description: description),
    ];
    return out[0];
  }

  Future<List<LandmarkDelta>> getAllLandmarkDeltasWithYear(int year) async {
    List<LandmarkDelta> allLandmarkDeltas = await getAllLandmarkDeltas();
    final List<LandmarkDelta> output = [];

    for (var landmarkDelta in allLandmarkDeltas) {
      var landmarkYear = landmarkDelta.dateTime.year;
      if (landmarkYear == year) {
        output.add(landmarkDelta);
      }
    }
    return output;
  }

  Future<List<LandmarkDelta>> getAllLandmarkDeltasWithYearAndMonth(
      int year, int month) async {
    List<LandmarkDelta> allLandmarkDeltas = await getAllLandmarkDeltas();
    final List<LandmarkDelta> output = [];

    for (var landmarkDelta in allLandmarkDeltas) {
      var landmarkYear = landmarkDelta.dateTime.year;
      var landmarkMonth = landmarkDelta.dateTime.month;
      if (landmarkYear == year && landmarkMonth == month) {
        output.add(landmarkDelta);
      }
    }
    return output;
  }

  Future<void> insertLandmarkData(LandmarkDelta landmarkDelta) async {
    final db = await _databaseService.db;
    await db.rawInsert(
        "INSERT INTO landmark_delta (name, date_time, weighting, description) VALUES (?,?,?,?)",
        [
          landmarkDelta.name,
          landmarkDelta.dateTime.toIso8601String(),
          landmarkDelta.weighting,
          landmarkDelta.description
        ]);
  }
}
