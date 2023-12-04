// import 'package:iteration_one_fitness_tracker/core/utilities/utils.dart';

// import '../../data/sources/table_attributes.dart';

// class DailyGoal {
//   late String _id;
//   String _date = MyUtils.getCurrentDateAsSqlFormat();
//   int _steps = 0;
//   int _workoutCalories = 0;
//   int _totalCalories = 0;
//   double _distance = 0.0;
//   double _activeTime = 0;

//   DailyGoal(
//       {required String id,
//       required String date,
//       required int steps,
//       required int workoutCalories,
//       required int totalCalories,
//       required double distance,
//       required double activeTime}) {
//     _id = id;
//     _date = date;
//     _steps = steps;
//     _workoutCalories = workoutCalories;
//     _totalCalories = totalCalories;
//     _distance = distance;
//     _activeTime = activeTime;
//   }

//   DailyGoal.fromMap(Map<String, dynamic> map)
//       : this(
//           id: map[DailyGoalFields.id],
//           date: map[DailyGoalFields.date],
//           steps: map[DailyGoalFields.steps],
//           workoutCalories: map[DailyGoalFields.workoutCalories],
//           totalCalories: map[DailyGoalFields.totalCalories],
//           distance: map[DailyGoalFields.distance],
//           activeTime: map[DailyGoalFields.activeTime],
//         );

//   Map<String, dynamic> toMap() {
//     return {
//       DailyGoalFields.id: _id,
//       DailyGoalFields.date: _date,
//       DailyGoalFields.steps: _steps,
//       DailyGoalFields.workoutCalories: _workoutCalories,
//       DailyGoalFields.totalCalories: _totalCalories,
//       DailyGoalFields.distance: _distance,
//       DailyGoalFields.activeTime: _activeTime,
//     };
//   }

//   @override
//   String toString() {
//     return "{id: $_id, date: $_date, steps: $_steps, activityCalories: $_workoutCalories, totalCalories: $_totalCalories, distance: $_distance, activeTime: $_activeTime}";
//   }
// }
