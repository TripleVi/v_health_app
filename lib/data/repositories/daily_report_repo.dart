import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../sources/table_attributes.dart';
import '../sources/sqlite/sqlite_service.dart';
import '../../domain/entities/activity_record.dart';
import '../../domain/entities/daily_steps.dart';
import '../../domain/entities/report.dart';
import '../../core/utilities/utils.dart';

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

  // Future tableType() async {
  //   final db = await SqlService.instance.database;
  //   var resultSet =
  //       await db.rawQuery('PRAGMA table_info(${ReportFields.container})');
  // }

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

  // void clearTable() async {
  //   final db = await SqlService.instance.database;
  //   await db.delete(ActivityRecordFields.container);
  //   await db.delete(ReportFields.container);
  // }

  Future<void> updateDailyReport(DailySummary summary) async {
    final db = await SqlService.instance.database;
    await db.update(
      DailySummaryFields.container, 
      summary.toMap(),
      where: '${DailySummaryFields.date} = ?',
      whereArgs: [summary.date]
    );
  }

  Future<void> createDailyReport(DailySummary summary) async {
    final db = await SqlService.instance.database;
    await db.insert(
      DailySummaryFields.container, 
      summary.toMap(),
    );
  }

  Future<DailySummary?> fetchDailyReport(String date) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      DailySummaryFields.container,
      where: "${DailySummaryFields.date} = ?", 
      whereArgs: [date],
    );
    return result.isNotEmpty 
        ? DailySummary.fromMap(result.first)
        : null;
  }

  Future<List<DailySummary>> fetchReportByDays(String startDate, int days) async {
    final db = await SqlService.instance.database;
    List<DailySummary> summaries = [];
    for (int i = 0; i < days; i++) {
      final date = MyUtils.get_date_subtracted_by_i(startDate, i);
      final result = await db.query(
        DailySummaryFields.container,
        where: '${DailySummaryFields.date} = ?',
        whereArgs: [date],
      );
      summaries.add(
        result.isEmpty 
            ? DailySummary.fromDate(date) 
            : DailySummary.fromMap(result.first)
      );
    }
    summaries.sort((a, b) => a.date.compareTo(b.date));
    return summaries;
  }

  Future<List<DailySummary>> fetchWeeklyReport(String startDate) async {
    final db = await SqlService.instance.database;
    final summaries = <DailySummary>[];
    for (int i = 0; i < 7; i++) {
      final date = MyUtils.get_date_subtracted_by_i(startDate, i);
      var result = await db.query(
        DailySummaryFields.container,
        where: '${DailySummaryFields.date} = ?',
        whereArgs: [date]
      );
      summaries.add(
        result.isEmpty 
            ? DailySummary.fromDate(date) 
            : DailySummary.fromMap(result.first),
      );
    }
    summaries.sort((a, b) => a.date.compareTo(b.date));
    return summaries;
  }

  // Future initTodayReport() async {
  //   final db = await SqlService.instance.database;
  //   var res = await db.query(DailySummaryFields.container,
  //       where: '${DailySummaryFields.date} = ?',
  //       whereArgs: [MyUtils.getCurrentDateAsSqlFormat()]);

  //   if (res.isEmpty) {
  //     await db.insert(DailySummaryFields.container,
  //         DailySummary.fromDate(MyUtils.getCurrentDateAsSqlFormat()).toJson(),
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   }
  // }

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
