import "package:quiver/time.dart" as qv;

import "../../domain/entities/daily_report.dart";
import "../sources/table_attributes.dart";
import "../sources/sqlite/sqlite_service.dart";
import "../../core/utilities/utils.dart";
import "daily_goal_repo.dart";

class DailyReportRepo {

  Future<int> updateDailyReport(DailyReport report) async {
    final db = await SqlService.instance.database;
    return db.update(
      DailyReportFields.container, 
      report.toSqlite(),
      where: '${DailyReportFields.date} = ?',
      whereArgs: [MyUtils.getDateAsSqlFormat(report.date)],
    );
  }

  Future<int> createDailyReport(DailyReport report) async {
    final db = await SqlService.instance.database;
    return db.insert(
      DailyReportFields.container, 
      report.toSqlite(),
    );
  }

  Future<DailyReport> fetchDailyReport(DateTime date) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      DailyReportFields.container,
      where: "${DailyReportFields.date} = ?", 
      whereArgs: [MyUtils.getDateAsSqlFormat(date)],
    );
    if(result.isEmpty) {
      return DailyReport.fromDate(date);
    }
    final report = DailyReport.fromSqlite(result.first);
    final goalRepo = DailyGoalRepo();
    report.goal = await goalRepo.fetchGoal(report.goal.id);
    return report;
  }

  Future<DailyReport> fetchTodayReport() {
    return fetchDailyReport(DateTime.now());
  }

  Future<List<DailyReport>> fetchRecentReports(DateTime date, int days) async {
    final reports = <DailyReport>[];
    for (int i = 0; i < days; i++) {
      final aDate = date.subtract(Duration(days: i));
      final report = await fetchDailyReport(aDate);
      reports.insert(0, report);
    }
    return reports;
  }

  Future<List<DailyReport>> fetchReportsByWeek(DateTime startOfWeek) async {
    final reports = <DailyReport>[];
    for (int i = 0; i < 7; i++) {
      final aDate = startOfWeek.add(Duration(days: i));
      final report = await fetchDailyReport(aDate);
      reports.add(report);
    }
    return reports;
  }

  Future<List<DailyReport>> fetchReportsByMonth(DateTime startOfMonth) async {
    final reports = <DailyReport>[];
    final days = qv.daysInMonth(startOfMonth.year, startOfMonth.month);
    for (int i = 0; i < days; i++) {
      final aDate = startOfMonth.add(Duration(days: i));
      final report = await fetchDailyReport(aDate);
      reports.add(report);
    }
    return reports;
  }

  Future<List<DailyReport>> fetchWeeklyReport(String startDate) async {
    final db = await SqlService.instance.database;
    final summaries = <DailyReport>[];
    for (int i = 0; i < 7; i++) {
      final txtDate = MyUtils.get_date_subtracted_by_i(startDate, i);
      var result = await db.query(
        DailyReportFields.container,
        where: '${DailyReportFields.date} = ?',
        whereArgs: [txtDate]
      );
      summaries.add(
        result.isEmpty 
            ? DailyReport.fromDate(MyUtils.getDateFromSqlFormat(txtDate)) 
            : DailyReport.fromSqlite(result.first),
      );
    }
    summaries.sort((a, b) => a.date.compareTo(b.date));
    return summaries;
  }
}
