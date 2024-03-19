import 'package:neo_delta/services/current_datetime.dart';
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
    // print( "Database Stored in: ${join(await getDatabasesPath(), 'neo_delta.db')}");
    return await openDatabase(join(await getDatabasesPath(), 'neo_delta.db'),
        onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS "landmark_delta" (
            "id" INTEGER NOT NULL UNIQUE,
            "name" VARCHAR(50) NOT NULL,
            "date_time" DATETIME NOT NULL,
            "description" VARCHAR(200) NOT NULL,
            "weighting" INTEGER NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
          )
          ''');
    await db.execute('''
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
    await db.execute('''
          CREATE TABLE IF NOT EXISTS "delta_progress" (
            "id" INTEGER NOT NULL UNIQUE,
            "delta_id" INTEGER NOT NULL,
            "completed_at" DATETIME NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY ("delta_id") REFERENCES "recurring_delta"("id")
          )
          ''');

    // SAMPLE DATA
    List<String> landmarkDeltaData = [
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('PROMOTION TO SENIOR ENGINEER', '2024-02-23T19:05:13.514986', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem.', '10');''',
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('SUCCESSFULLY MANAGED AND LED PROJECT NEODELTA', '2024-02-23T19:05:25.136053', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. ', '10');''',
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('COMPLETED CERTIFICATIONS IN PROJECT MANAGEMENT AND DATA ANALYSIS.', '2024-02-23T19:05:42.243790', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. ', '10');''',
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('SUCCESSFULLY LED A CROSS-FUNCTIONAL TEAM TO ACHIEVE A 25% INCREASE IN PRODUCTIVITY', '2024-02-23T19:06:01.606056', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem.', '10');''',
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('MENTORED AND DEVELOPED THREE TEAM MEMBERS', '2024-02-23T19:06:21.676546', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent nulla mauris, malesuada quis tempus vitae, pharetra a sem. ', '10');''',
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('BACKEND SUCCESSFULLY CONNECTED TO FRONTEND', '2024-03-18T15:17:24.582189', 'Recurring Delta and Landmark Deltas are done', '10');''',
      '''INSERT INTO landmark_delta ("name", "date_time", "description", "weighting") VALUES ('Version 1 Complete', '2024-03-18T15:20:13.859470', 'NeoDelta V1 is finished!', '8');'''
    ];

    for (var statement in landmarkDeltaData) {
      await db.execute(statement);
    }

    List<String> recurringDeltaData = [
      '''INSERT INTO recurring_delta ("name", "icon_src", "interval", "weighting", "minimum_volume", "effective_volume", "optimal_volume", "start_date") VALUES ('MORNING ROUTINE', 'assets/landmark.png', 'DeltaInterval.day', '8', '1', '1', '1', '2024-03-10 20:27:02.419543');''',
      '''INSERT INTO recurring_delta ("name", "icon_src", "interval", "weighting", "minimum_volume", "effective_volume", "optimal_volume", "start_date") VALUES ('GYM', 'assets/landmark.png', 'DeltaInterval.week', '8', '3', '5', '6', '2024-03-10 20:26:14.778616');''',
      '''INSERT INTO recurring_delta ("name", "icon_src", "interval", "weighting", "minimum_volume", "effective_volume", "optimal_volume", "start_date") VALUES ('PIANO', 'assets/landmark.png', 'DeltaInterval.week', '4', '1', '1', '1', '2024-03-10 20:27:31.078446');''',
      '''INSERT INTO recurring_delta ("name", "icon_src", "interval", "weighting", "minimum_volume", "effective_volume", "optimal_volume", "start_date") VALUES ('BADMINTON', 'assets/landmark.png', 'DeltaInterval.week', '6', '1', '2', '2', '2024-03-10 20:27:31.078446');'''
    ];

    for (var statement in recurringDeltaData) {
      await db.execute(statement);
    }

    var rawMorningId = await db.rawQuery(
        "SELECT id FROM recurring_delta WHERE name = 'MORNING ROUTINE'");

    int morningId = rawMorningId[0]["id"] as int;

    List<String> deltaProgressMorning = [
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-01-24 07:42:49.047000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-01-28 09:07:35.646000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-02 07:34:33.252000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-05 07:07:37.751000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-07 06:56:18.328000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-07 06:56:26.496000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-13 07:27:31.108000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-14 07:46:54.678000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-15 07:36:24.624000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-17 09:06:41.415000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-18 08:31:13.592000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-23 07:10:25.856000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-24 08:27:07.363000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-02-28 06:50:38.448000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-03-01 07:45:07.195000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-03-04 07:32:02.746000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-03-08 08:44:28.566000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-03-13 06:24:11.416000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-03-15 06:00:23.024000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-03-18 07:16:15.415000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$morningId", "2024-01-23 13:24:08.039000");'''
    ];

    for (var statement in deltaProgressMorning) {
      await db.execute(statement);
    }

    var rawGymId =
        await db.rawQuery("SELECT id FROM recurring_delta WHERE name = 'GYM'");

    int gymId = rawGymId[0]["id"] as int;

    List<String> deltaProgressGym = [
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-01-23 13:24:08.041000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-01-23 13:24:08.042000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-01-24 07:42:50.525000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-01-28 09:07:38.406000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-01-30 10:20:31.818000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-02 07:34:35.251000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-05 08:08:22.014000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-06 07:40:17.105000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-07 07:50:09.245000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-08 09:44:45.911000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-13 07:27:32.523000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-14 07:46:56.032000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-15 07:36:25.778000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-17 09:06:52.516000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-18 08:31:14.647000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-19 10:45:32.837000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-21 10:51:31.797000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-22 11:09:43.658000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-23 07:10:27.304000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-24 08:27:08.534000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-25 14:56:53.912000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-26 11:12:19.477000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-28 07:27:23.799000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-02-29 11:24:31.156000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-01 07:45:04.482000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-02 13:17:20.732000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-03 12:30:17.051000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-04 07:31:56.855000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-06 08:51:53.032000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-07 10:10:50.884000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-08 08:44:23.558000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-10 00:43:58.238000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-10 11:12:46.894000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-11 10:57:15.663000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-13 07:46:58.265000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-14 12:59:18.876000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-15 07:32:14.607000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-16 12:17:23.619000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-17 12:23:01.571000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$gymId", "2024-03-18 07:16:16.950000");'''
    ];
    for (var statement in deltaProgressGym) {
      await db.execute(statement);
    }

    var rawPianoId = await db
        .rawQuery("SELECT id FROM recurring_delta WHERE name = 'PIANO'");
    int pianoId = rawPianoId[0]["id"] as int;

    List<String> deltaProgressPiano = [
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-01-23 20:12:48.290000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-01-23 20:12:48.290000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-01-24 17:17:38.327000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-02-03 11:59:11.784000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-02-14 15:03:41.892000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-02-19 10:45:32.854000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-02-29 12:33:13.408000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-03-05 09:56:02.493000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$pianoId", "2024-03-14 10:54:59.543000");'''
    ];

    for (var statement in deltaProgressPiano) {
      await db.execute(statement);
    }

    var rawBadmintonId = await db
        .rawQuery("SELECT id FROM recurring_delta WHERE name = 'BADMINTON'");
    int badmintonId = rawBadmintonId[0]["id"] as int;

    List<String> deltaProgressBadminton = [
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-05 21:31:00.768000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-05 21:31:00.762000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-05 21:30:42.818000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-05 21:30:42.824000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-05 21:30:34.552000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-12 16:10:10.009000");''',
      '''INSERT INTO delta_progress ("delta_id", "completed_at") VALUES ("$badmintonId", "2024-03-14 10:55:00.698000");'''
    ];

    for (var statement in deltaProgressBadminton) {
      await db.execute(statement);
    }
  }

  Future<DateTime> getFirstDeltaEntryDate() async {
    final db = await this.db;
    var recurringDeltaData =
        await db.rawQuery("SELECT MIN(id), start_date FROM recurring_delta");
    var landmarkDeltaData =
        await db.rawQuery("SELECT MIN(id), date_time FROM landmark_delta");

    DateTime earliest = currentDateTime();

    if (recurringDeltaData.isNotEmpty) {
      DateTime firstRecurringDeltaDate =
          DateTime.parse(recurringDeltaData[0]["start_date"] as String);
      earliest = DateTime(firstRecurringDeltaDate.year,
          firstRecurringDeltaDate.month, firstRecurringDeltaDate.day);
    }

    if (landmarkDeltaData.isNotEmpty) {
      DateTime firstLandmarkDeltaDate =
          DateTime.parse(landmarkDeltaData[0]["date_time"] as String);

      if (firstLandmarkDeltaDate.isBefore(earliest)) {
        earliest = DateTime(firstLandmarkDeltaDate.year,
            firstLandmarkDeltaDate.month, firstLandmarkDeltaDate.day);
      }
    }

    return earliest;
  }
}
