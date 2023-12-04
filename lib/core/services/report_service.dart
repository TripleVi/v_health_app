import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../data/sources/table_attributes.dart';
import '../../data/sources/sqlite/sqlite_service.dart';
import '../../domain/entities/activity_record.dart';
import '../../domain/entities/daily_steps.dart';
import '../../domain/entities/report.dart';
import '../utilities/utils.dart';

class ReportService {
  static final ReportService instance = ReportService._init();
  ReportService._init();

  // Future addReport(ActivityRecord record) async {
  //   final db = await SqlService.instance.database;
  //   var recordMap = record.toMap();
  //   return await db.insert(ActivityRecordFields.container, recordMap,
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future updateReport(ActivityRecord record) async {
  //   final db = await SqlService.instance.database;
  //   var recordMap = record.toMap();
  // }

  Future tableType() async {
    final db = await SqlService.instance.database;
    var resultSet =
        await db.rawQuery('PRAGMA table_info(${ReportFields.container})');
  }

  // Future<List<Report>> fetchReport() async {
  //   final db = await SqlService.instance.database;
  //   final result = await db.query(ReportFields.container);
  //   List<Report> res = result.map((map) => Report.fromMap(map)).toList();
  //   return res;
  // }

  // Future<ActivityRecord> fetchReportByDate(DateTime date) async {
  //   final db = await SqlService.instance.database;
  //   final result = await db.query(ActivityRecordFields.container,
  //       where: "${ActivityRecordFields.startDate} = ?", whereArgs: [date]);
  //   if (result.isEmpty) {
  //     return ActivityRecord(startDate: date, endDate: DateTime.now());
  //   }
  //   return ActivityRecord.fromMap(result.first);
  // }

  Future<List<Report>> fetchHourlyReport(String date) async {
    final db = await SqlService.instance.database;

    List<Report> result = [];
    for (int i = 0; i < 24; i++) {
      var res = await db.query(ReportFields.container,
          where: "${ReportFields.date} = ? AND ${ReportFields.hour} = ?",
          whereArgs: [date, i]);
      if (res.isEmpty) {
        final temp = Report.empty()
        ..date = date
        ..hour = i;
        result.add(temp);
      } else {
        result.add(fromMap(res.first));
      }
    }

    return result;
  }

  Report fromMap(Map<String, dynamic> map) {
    return Report(rid: map["rid"], date: map["date"], hour: map["hour"], steps: map["steps"], distance: map["distance"], stair: map["stair"], calories: map["calories"]);
  }

  // Future addMockHourlyReport(String startDate, int duration) async {
  //   var records = [];
  //   var random = Random();
  //   int index = 0;
  //   for (int j = 0; j < duration; j++) {
  //     for (int i = 0; i < 24; i++) {
  //       Report r = Report.empty(
  //           index.toString(),
  //           MyUtils.get_date_subtracted_by_i(startDate, j),
  //           i,
  //           i > 5 && i < 21 ? random.nextInt(200) : 0,
  //           i > 5 && i < 21 ? random.nextInt(10) / 10 : 0,
  //           i > 5 && i < 21 ? random.nextInt(40) : 0,
  //           i > 5 && i < 21 ? random.nextInt(10) : 0);
  //       records.add(r);
  //       index++;
  //     }
  //   }

  //   final database = await SqlService.instance.database;
  //   final Batch batch = database.batch();

  //   for (var record in records) {
  //     batch.insert(ReportFields.container, record.toJson(),
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   }

  //   await batch.commit();
  // }

  void clearTable() async {
    final db = await SqlService.instance.database;
    await db.delete(ActivityRecordFields.container);
    await db.delete(ReportFields.container);
  }

  getHourlyReportsByDate(String date) {}

  Future summarizeData(String date) async {
    final db = await SqlService.instance.database;
    List<Report> reports = await fetchHourlyReport(date);
    int steps = 0;
    int stair = 0;
    int calories = 0;
    for (int i = 0; i < reports.length; i++) {
      steps += reports[i].steps;
      stair += reports[i].stair;
      calories += reports[i].calories;
    }
    DailySummary d = DailySummary(date, steps, steps * 0.0025, stair, calories);
    await db.insert(DailySummaryFields.container, d.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<DailySummary> fetchDailyReport(String date) async {
    final db = await SqlService.instance.database;
    final result = await db.query(DailySummaryFields.container,
        where: "${DailySummaryFields.date} = ?", whereArgs: [date]);
    List<DailySummary> res =
        result.map((map) => DailySummary.fromMap(map)).toList();

    return res.isNotEmpty ? res.first : DailySummary.fromDate(date);
  }

  Future<List<DailySummary>> fetchReportByDays(
      String startDate, int days) async {
    final db = await SqlService.instance.database;
    List<DailySummary> result = [];

    for (int i = 0; i < days; i++) {
      var day = await db.query(DailySummaryFields.container,
          where: '${DailySummaryFields.date} = ?',
          whereArgs: [MyUtils.get_date_subtracted_by_i(startDate, i)]);

      if (day.isEmpty) {
        result.add(DailySummary.fromDate(
            MyUtils.get_date_subtracted_by_i(startDate, i)));
      } else {
        result.add(DailySummary.fromMap(day[0]));
      }
    }

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  Future<List<DailySummary>> fetchWeeklyReport(String startDate) async {
    final db = await SqlService.instance.database;
    List<DailySummary> result = [];

    for (int i = 0; i < 7; i++) {
      var day = await db.query(DailySummaryFields.container,
          where: '${DailySummaryFields.date} = ?',
          whereArgs: [MyUtils.get_date_subtracted_by_i(startDate, i)]);
      ReportService.instance
          .summarizeData(MyUtils.get_date_subtracted_by_i(startDate, i));
      if (day.isEmpty) {
        result.add(DailySummary.fromDate(
            MyUtils.get_date_subtracted_by_i(startDate, i)));
      } else {
        result.add(DailySummary.fromMap(day[0]));
      }
    }

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  Future initTodayReport() async {
    final db = await SqlService.instance.database;
    var res = await db.query(DailySummaryFields.container,
        where: '${DailySummaryFields.date} = ?',
        whereArgs: [MyUtils.getCurrentDateAsSqlFormat()]);

    if (res.isEmpty) {
      await db.insert(DailySummaryFields.container,
          DailySummary.fromDate(MyUtils.getCurrentDateAsSqlFormat()).toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Future addMockTodayReport() async {
  //   var records = [];
  //   var random = Random();
  //   int index = 0;

  //   for (int i = 0; i < 24; i++) {
  //     Report r = Report.newReport(
  //         const Uuid().v4(),
  //         MyUtils.getCurrentDateAsSqlFormat(),
  //         i,
  //         i > 5 && i < DateTime.now().hour ? random.nextInt(400) : 0,
  //         i > 5 && i < DateTime.now().hour ? random.nextInt(10) / 10 : 0,
  //         i > 5 && i < DateTime.now().hour ? random.nextInt(40) : 0,
  //         i > 5 && i < DateTime.now().hour ? random.nextInt(200) : 0);
  //     records.add(r);
  //     index++;
  //   }

  //   final database = await SqlService.instance.database;
  //   final Batch batch = database.batch();

  //   for (var record in records) {
  //     batch.insert(ReportFields.container, record.toJson(),
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   }

  //   await batch.commit();
  // }
}
