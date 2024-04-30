import "../../domain/entities/report.dart";
import "../sources/sqlite/sqlite_service.dart";
import "../sources/table_attributes.dart";

class HourlyReportRepo {

  Future<Report> fetchReport(int dateId, int hour) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      HourlyReportFields.container,
      where: "${HourlyReportFields.dayId} = ? AND ${HourlyReportFields.hour} = ?",
      whereArgs: [dateId, hour],
    );
    return result.isNotEmpty 
        ? Report.fromSqlite(result.first) 
        : Report.fromHour(hour);
  }

  Future<List<Report>> fetchReportsByDate(int dateId) async {
    final reports = <Report>[];
    for (int i = 0; i < 24; i++) {
      final report = await fetchReport(dateId, i);
      reports.add(report);
    }
    return reports;
  }

  Future<int> updateReport(Report report) async {
    final db = await SqlService.instance.database;
    return db.update(
      HourlyReportFields.container, 
      report.toSqlite(),
      where: '${HourlyReportFields.dayId} = ? AND ${HourlyReportFields.hour} = ?',
      whereArgs: [report.day.id, report.hour],
    );
  }

  Future<int> createReport(Report report) async {
    final db = await SqlService.instance.database;
    return db.insert(HourlyReportFields.container, report.toSqlite());
  }
}
