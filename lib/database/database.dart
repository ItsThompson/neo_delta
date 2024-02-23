import 'package:neo_delta/models/landmark_delta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // print("Database Stored in: ${join(await getDatabasesPath(), 'neo_delta.db')}");
    return await openDatabase(join(await getDatabasesPath(), 'neo_delta.db'),
        onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
          CREATE TABLE IF NOT EXISTS "landmark_delta" (
            "id" INTEGER NOT NULL UNIQUE,
            "name" VARCHAR(50) NOT NULL,
            "date_time" DATETIME NOT NULL,
            "description" VARCHAR(200) NOT NULL,
            "weighting" INTEGER NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
          )
          """);
  }

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