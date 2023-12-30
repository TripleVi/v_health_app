import 'package:sqflite/sqflite.dart';

import '../../domain/entities/report.dart';
import '../sources/sqlite/sqlite_service.dart';
import '../sources/table_attributes.dart';

class HourlyReportRepo {
  static final instance = HourlyReportRepo._();

  HourlyReportRepo._();

  Future<Report?> fetchReport(String date, int hour) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      ReportFields.container,
      where: "${ReportFields.date} = ? AND ${ReportFields.hour} = ?",
      whereArgs: [date, hour],
    );
    return result.isNotEmpty ? Report.fromMap(result.first) : null;
  }

  Future<List<Report>> fetchDailyReport(String date) async {
    final db = await SqlService.instance.database;
    List<Report> result = [];
    for (int i = 0; i < 24; i++) {
      var res = await db.query(
        ReportFields.container,
        where: "${ReportFields.date} = ? AND ${ReportFields.hour} = ?",
        whereArgs: [date, i]
      );
      if (res.isEmpty) {
        final temp = Report.empty()
        ..date = date
        ..hour = i;
        result.add(temp);
      } else {
        result.add(Report.fromMap(res.first));
      }
    }
    return result;
  }

  Future<int> updateReport(Report report) async {
    final db = await SqlService.instance.database;
    final newReport = report.toMap();
    return db.update(
      ReportFields.container, 
      newReport,
      where: '${ReportFields.date} = ? AND ${ReportFields.hour} = ?',
      whereArgs: [report.date, report.hour],
    );
  }

  Future<int> createReport(Report report) async {
    Database db = await SqlService.instance.database;
    final newReport = report.toMap();
    return db.insert(ReportFields.container, newReport);
  }
}
