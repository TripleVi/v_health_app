import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/report.dart';
import '../sources/sqlite/sqlite_service.dart';
import '../sources/table_attributes.dart';

class HourlyReportRepo {
  static final instance = HourlyReportRepo._();

  HourlyReportRepo._();

  Report fromMap(Map<String, dynamic> map) {
    return Report(rid: map["rid"], date: map["date"], hour: map["hour"], steps: map["steps"], distance: map["distance"], stair: map["stair"], calories: map["calories"]);
  }

  Map<String, dynamic> toMap(Report report) {
    return {
      "rid": report.rid, "date": report.date, "hour": report.hour, "steps": report.steps, "distance": report.distance, "stair": report.stair, "calories": report.calories,
    };
  }

  Future<Report?> getHourlyReport(String date, int hour) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      ReportFields.container,
      where: "${ReportFields.date} = ? AND ${ReportFields.hour} = ?",
      whereArgs: [date, hour],
    );
    return result.isNotEmpty ? fromMap(result.first) : null;
  }

  Future<int> updateReport({
    required Report report,
    required String date, 
    required int hour, 
  }) async {
    final db = await SqlService.instance.database;
    final newReport = toMap(report);
    return db.update(
      ReportFields.container, 
      newReport,
      where: '${ReportFields.date} = ? AND ${ReportFields.hour} = ?',
      whereArgs: [date, hour],
    );
  }

  Future<int> addReport(Report report) async {
    Database db = await SqlService.instance.database;
    final newReport = toMap(report);
    return db.insert(ReportFields.container, newReport);
  }
}
