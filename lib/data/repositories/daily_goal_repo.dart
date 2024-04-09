import '../../../../domain/entities/daily_goal.dart';
import '../sources/sqlite/dao/daily_goal_dao.dart';

class DailyGoalRepo {
  final goalDao = DailyGoalDao();

  Future<DailyGoal> fetchGoal(int goalId) {
    return goalDao.fetchGoal(goalId);
  }

  Future<DailyGoal> fetchLatestGoal() {
    return goalDao.fetchLatestGoal();
  }

  Future<int> createGoal(DailyGoal goal) {
    return goalDao.createGoal(goal);
  }

  Future<int> createDefaultGoal() {
    return goalDao.createGoal(DailyGoal.empty());
  }

  Future<int> updateGoal(DailyGoal goal) {
    return goalDao.updateGoal(goal);
  }
  
}
