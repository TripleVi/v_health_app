import '../../../../domain/entities/workout_data.dart';
import '../sqlite_service.dart';

class WorkoutDao {
  Future<void> insertManyWorkoutData(List<WorkoutData> data) async {
    final db = await SqlService.instance.database;
    final batch = db.batch();
    for (var d in data) {
      batch.insert("workout_session", d.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<WorkoutData>> getManyAccelData() async {
    final db = await SqlService.instance.database;
    final result = await db.query("workout_session");
    return result.map((e) => WorkoutData.fromMap(e)).toList();
  }

  Future<void> clearTable() async {
    final db = await SqlService.instance.database;
    final affectedRows = await db.delete("workout_session");
    print("Affected rows: $affectedRows");
  }
}
