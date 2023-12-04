// import 'package:iteration_one_fitness_tracker/data/sources/sqlite/sqlite_service.dart';
// import 'package:iteration_one_fitness_tracker/data/sources/table_attributes.dart';
// import 'package:iteration_one_fitness_tracker/domain/entities/accel_data.dart';

// class AccelDataDao {
//   static final AccelDataDao instance = AccelDataDao.init();

//   AccelDataDao.init();

//   Future<List<AccelData>> fetchHour(int hour, String date) async {
//     final db = await SqlService.instance.database;
//     final result = await db.query(
//       AccelDataFields.table,
//       where: "${AccelDataFields.Hour} = ? and ${AccelDataFields.Date} = ? ",
//       whereArgs: [hour, date],
//     );
//     List<AccelData> res = result.map((map) => AccelData.fromMap(map)).toList();
//     return res;
//   }

//   Future<List<AccelData>> fetchQuarter(
//       int quarter, int hour, String date) async {
//     final db = await SqlService.instance.database;
//     final result = await db.query(AccelDataFields.table,
//         where:
//             "${AccelDataFields.Quarter} = ? and ${AccelDataFields.Hour} = ? and ${AccelDataFields.Date} = ? ",
//         whereArgs: [quarter, hour, date],
//         orderBy: '${AccelDataFields.T} ASC');
//     List<AccelData> res = result.map((map) => AccelData.fromMap(map)).toList();
//     return res;
//   }

//   Future<List<AccelData>> fetchByHour(int hour, String date) async {
//     final db = await SqlService.instance.database;
//     final result = await db.query(
//       AccelDataFields.table,
//       where: "${AccelDataFields.Hour} = ? and ${AccelDataFields.Date} = ? ",
//       whereArgs: [hour, date],
//     );
//     List<AccelData> res = result.map((map) => AccelData.fromMap(map)).toList();
//     return res;
//   }

//   Future<List<AccelData>> fetchAll() async {
//     final db = await SqlService.instance.database;
//     final result = await db.query(
//       AccelDataFields.table,
//     );
//     List<AccelData> res = result.map((map) => AccelData.fromMap(map)).toList();
//     return res;
//   }
// }
