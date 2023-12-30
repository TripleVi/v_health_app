import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'sqlite_constants.dart';

class SqlService {
  static final SqlService instance = SqlService._init();

  static Database? _database;

  SqlService._init();

  Future<Database> get database async =>
      _database ??= await _initDatabase(sqlitePath);

  Future<Database> _initDatabase(String filepath) async {
    String dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    Database d =
        await openDatabase(path, version: 1, onCreate: createDatabase);
    return d;
  }

  static Future createDatabase(Database db, int version) async {
    await db.execute(createReportTable);
    await db.execute(createDailySummaryTable);
    // await db.execute(createUserTable);
    // await db.execute(createActivityRecordTable);
    // await db.execute(createCoordinateTable);
    // await db.execute(createPhotoTable);
    // await db.execute(createAccelDataTable);
    // await db.execute(createPostTable);
    // await db.execute(createWorkoutSessionTable);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
