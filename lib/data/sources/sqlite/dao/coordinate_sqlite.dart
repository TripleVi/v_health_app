// import 'package:sqflite/sqflite.dart';

// import '../../../../domain/entities/coordinate.dart';
// import '../../table_attributes.dart';

// class CoordinateSqlite {
//   final Future<Database> _dbFuture;

//   CoordinateSqlite(this._dbFuture);

//   Future<List<Coordinate>> getCoordinates(String activityRecordId) async {
//     final db = await _dbFuture;
//     final maps = await db.query(
//       CoordinateFields.container,
//       where: "${CoordinateFields.recordId} = ?", 
//       whereArgs: [activityRecordId],
//     );
//     return maps.map((map) {
//       return Coordinate.fromMap(map);
//     }).toList();
//   }

//   Future<bool> deleteCoordinates(String activityRecordId) async {
//     final db = await _dbFuture;
//     final batch = db.batch();
//     batch.delete(
//       CoordinateFields.container,
//       where: "${CoordinateFields.recordId} = ?",
//       whereArgs: [activityRecordId],
//     );
//     final result = await batch.commit(noResult: false);
//     return result.isNotEmpty;
//   }
// }
