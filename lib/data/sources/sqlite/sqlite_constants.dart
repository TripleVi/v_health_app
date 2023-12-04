import '../table_attributes.dart';

const sqlitePath = "fitness_tracker.db";
const createDailySummaryTable =
    "CREATE TABLE IF NOT EXISTS ${DailySummaryFields.container}("
    "${DailySummaryFields.date} TEXT PRIMARY KEY, "
    "${DailySummaryFields.steps} INTEGER, "
    "${DailySummaryFields.distance} REAL, "
    "${DailySummaryFields.stair} INTEGER, "
    "${DailySummaryFields.calories} INTEGER)";

const createAccelDataTable =
    "CREATE TABLE IF NOT EXISTS ${AccelDataFields.table}("
    "${AccelDataFields.ID} INTEGER PRIMARY KEY, "
    "${AccelDataFields.X} REAL, "
    "${AccelDataFields.Y} REAL, "
    "${AccelDataFields.Z} REAL, "
    "${AccelDataFields.T} INTEGER,"
    "${AccelDataFields.Hour} INTEGER,"
    "${AccelDataFields.Quarter} INTEGER,"
    "${AccelDataFields.Date} TEXT,"
    "${AccelDataFields.Activity} TEXT)";

const createReportTable =
    "CREATE TABLE IF NOT EXISTS ${ReportFields.container}("
    "${ReportFields.rid} INTEGER PRIMARY KEY AUTOINCREMENT, "
    "${ReportFields.date} TEXT, "
    "${ReportFields.hour} INTEGER, "
    "${ReportFields.steps} INTEGER, "
    "${ReportFields.distance} REAL, "
    "${ReportFields.stair} INTEGER, "
    "${ReportFields.calories} INTEGER)";

const createUserTable = "CREATE TABLE IF NOT EXISTS ${UserFields.container}("
    "${UserFields.id} TEXT PRIMARY KEY, "
    "${UserFields.username} TEXT NOT NULL, "
    "${UserFields.password} TEXT NOT NULL, "
    "${UserFields.firstName} TEXT NOT NULL, "
    "${UserFields.lastName} TEXT NOT NULL, "
    "${UserFields.dob} TEXT NOT NULL, "
    "${UserFields.gender} INTEGER NOT NULL, "
    "${UserFields.height} REAL, "
    "${UserFields.weight} REAL, "
    "${UserFields.avatarName} TEXT NOT NULL, "
    "${UserFields.avatarUrl} TEXT NOT NULL)";

const createDailyGoalTable =
    "CREATE TABLE IF NOT EXISTS ${DailyGoalFields.container}("
    "${DailyGoalFields.id} TEXT PRIMARY KEY, "
    "${DailyGoalFields.date} TEXT NOT NULL, "
    "${DailyGoalFields.steps} INTEGER NOT NULL, "
    "${DailyGoalFields.workoutCalories} REAL NOT NULL, "
    "${DailyGoalFields.totalCalories} REAL NOT NULL, "
    "${DailyGoalFields.distance} REAL NOT NULL, "
    "${DailyGoalFields.activeTime} REAL NOT NULL)";

const createActivityRecordTable =
    "CREATE TABLE IF NOT EXISTS ${ActivityRecordFields.container}("
    "${ActivityRecordFields.id} TEXT PRIMARY KEY, "
    "${ActivityRecordFields.startDate} INTEGER NOT NULL, "
    "${ActivityRecordFields.endDate} INTEGER NOT NULL, "
    "${ActivityRecordFields.workoutDuration} INTEGER, "
    "${ActivityRecordFields.distance} REAL, "
    "${ActivityRecordFields.avgSpeed} REAL, "
    "${ActivityRecordFields.maxSpeed} REAL, "
    "${ActivityRecordFields.avgPace} REAL, "
    "${ActivityRecordFields.maxPace} REAL, "
    "${ActivityRecordFields.steps} INTEGER, "
    "${ActivityRecordFields.stairsClimbed} INTEGER, "
    "${ActivityRecordFields.workoutCalories} REAL, "
    "${ActivityRecordFields.totalCalories} REAL, "
    "${ActivityRecordFields.mapName} TEXT)";

const createDailyStepsTable =
    "CREATE TABLE IF NOT EXISTS ${DailyStepsFields.container}("
    "${DailyStepsFields.id} TEXT PRIMARY KEY, "
    "${DailyStepsFields.date} TEXT NOT NULL, "
    "${DailyStepsFields.steps} TEXT NOT NULL, "
    "${DailyStepsFields.distance} REAL NOT NULL, "
    "${DailyStepsFields.calories} REAL NOT NULL)";

const createCoordinateTable =
    "CREATE TABLE IF NOT EXISTS ${CoordinateFields.container}("
    "${CoordinateFields.id} TEXT PRIMARY KEY, "
    "${CoordinateFields.latitude} REAL NOT NULL, "
    "${CoordinateFields.longitude} REAL NOT NULL, "
    "${CoordinateFields.timeFrame} INTEGER NOT NULL, "
    "${CoordinateFields.activityType} INTEGER, "
    "${CoordinateFields.recordId} INTEGER NOT NULL REFERENCES ${ActivityRecordFields.container}(${ActivityRecordFields.id}) ON UPDATE CASCADE)";

const createPhotoTable = "CREATE TABLE IF NOT EXISTS ${PhotoFields.container}("
    "${PhotoFields.id} TEXT PRIMARY KEY, "
    "${PhotoFields.name} TEXT NOT NULL, "
    "${PhotoFields.date} TEXT NOT NULL, "
    "${PhotoFields.latitude} REAL NOT NULL, "
    "${PhotoFields.longitude} REAL NOT NULL, "
    "${PhotoFields.recordId} INTEGER NOT NULL REFERENCES ${ActivityRecordFields.container}(${ActivityRecordFields.id}) ON DELETE CASCADE)";

const createPostTable = "CREATE TABLE IF NOT EXISTS ${PostFields.container}("
    "${PostFields.id} TEXT PRIMARY KEY, "
    "${PostFields.title} TEXT NOT NULL, "
    "${PostFields.content} TEXT NOT NULL, "
    "${PostFields.privacy} INTEGER NOT NULL, "
    "${PostFields.createdDate} INTEGER NOT NULL, "
    "${PhotoFields.recordId} TEXT NOT NULL REFERENCES ${ActivityRecordFields.container}(${ActivityRecordFields.id}) ON UPDATE CASCADE)";

const createWorkoutSessionTable = "CREATE TABLE IF NOT EXISTS ${WorkoutSessionFields.container}("
    "${WorkoutSessionFields.id} TEXT PRIMARY KEY, "
    "${WorkoutSessionFields.distance} REAL NOT NULL, "
    "${WorkoutSessionFields.speed} REAL NOT NULL, "
    "${WorkoutSessionFields.pace} REAL NOT NULL, "
    "${WorkoutSessionFields.timeFrame} INTEGER NOT NULL)";
