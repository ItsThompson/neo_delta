import 'package:neo_delta/models/recurring_delta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService();

  static Database? _database;
  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    print( "Database Stored in: ${join(await getDatabasesPath(), 'neo_delta.db')}");
    return await openDatabase(join(await getDatabasesPath(), 'neo_delta.db'),
        onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    db.execute('''
          CREATE TABLE IF NOT EXISTS "landmark_delta" (
            "id" INTEGER NOT NULL UNIQUE,
            "name" VARCHAR(50) NOT NULL,
            "date_time" DATETIME NOT NULL,
            "description" VARCHAR(200) NOT NULL,
            "weighting" INTEGER NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
          )
          ''');
    db.execute('''
          CREATE TABLE IF NOT EXISTS "recurring_delta" (
            "id" INTEGER NOT NULL UNIQUE,
            "name" VARCHAR(50) NOT NULL, 
            "icon_src" VARCHAR(200) NOT NULL,
            "interval" VARCHAR(5) NOT NULL,
            "weighting" INTEGER NOT NULL,
            "minimum_volume" INTEGER NOT NULL,
            "effective_volume" INTEGER NOT NULL,
            "optimal_volume" INTEGER NOT NULL,
            "start_date" DATETIME NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
          )
          ''');
    db.execute('''
          CREATE TABLE IF NOT EXISTS "delta_progress" (
            "id" INTEGER NOT NULL UNIQUE,
            "delta_id" INTEGER NOT NULL,
            "completed_at" DATETIME NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY ("delta_id") REFERENCES "recurring_delta"("id")
          )
          ''');
  }


  Future<DateTime> getFirstDeltaEntryDate() async {
    final db = await this.db;
    var recurringDeltaData = await db.rawQuery("SELECT MIN(id) FROM recurring_delta");
    var landmarkDeltaData = await db.query("SELECT MIN(id) FROM landmark_delta");

    DateTime earliest = DateTime.now();

    if (recurringDeltaData.isNotEmpty) {
      DateTime firstRecurringDeltaDate = DateTime.parse(recurringDeltaData[0]["start_date"] as String);
      earliest = firstRecurringDeltaDate;
    }

    if (landmarkDeltaData.isNotEmpty) {
      DateTime firstLandmarkDeltaDate = DateTime.parse(landmarkDeltaData[0]["date_time"] as String);

      if (firstLandmarkDeltaDate.isBefore(earliest)) {
        earliest = firstLandmarkDeltaDate;
      }
    }

    return earliest;
  }
}
