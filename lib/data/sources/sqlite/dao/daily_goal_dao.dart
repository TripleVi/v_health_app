import '../../../../domain/entities/daily_goal.dart';
import '../../table_attributes.dart';
import '../sqlite_service.dart';

class DailyGoalDao {

  Future<DailyGoal> fetchGoal(int goalId) async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      DailyGoalFields.container,
      where: "${DailyGoalFields.id} = ?",
      whereArgs: [goalId],
    );
    return result.isNotEmpty 
        ? DailyGoal.fromSqlite(result.first) 
        : DailyGoal.empty();
  }

  Future<DailyGoal> fetchLatestGoal() async {
    final db = await SqlService.instance.database;
    final result = await db.query(
      DailyGoalFields.container,
      orderBy: "${DailyGoalFields.id} DESC",
      limit: 1,
    );
    return DailyGoal.fromSqlite(result.first);
  }

  Future<int> createGoal(DailyGoal goal) async {
    final db = await SqlService.instance.database;
    return db.insert(DailyGoalFields.container, goal.toSqlite());
  }

  Future<int> deleteGoal(int goalId) async {
    final db = await SqlService.instance.database;
    return db.delete(
      DailyGoalFields.container,
      where: "${DailyGoalFields.id} = ?",
      whereArgs: [goalId],
    );
  }

  Future<int> updateGoal(DailyGoal goal) async {
    final latestGoal = await fetchLatestGoal();
    await deleteGoal(latestGoal.id);
    return createGoal(goal);
  }
  
}
