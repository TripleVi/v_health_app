import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/activity_record.dart';
import '../../table_attributes.dart';

class ActivityRecordSqlite {
  final Future<Database> _dbFuture;

  ActivityRecordSqlite(this._dbFuture);

  // Future<bool> insertActivityRecord(ActivityRecord value) async {
  //   final db = await _dbFuture;
  //   try {
  //     await db.transaction<void>((txn) async {
  //       final changes = await txn
  //           .insert(ActivityRecordFields.container, value.toMap());
  //       if(changes != 1) {
  //         throw Exception("Inserting activity record failed");
  //       }
  //       if(value.coordinates.isNotEmpty) {
  //         final batch = txn.batch();
  //         for (var coordinate in value.coordinates) {
  //           batch.insert(CoordinateFields.container, coordinate.toMap());
  //         }
  //         final result = await batch.commit(noResult: false);
  //         if(result.isEmpty) {
  //           throw Exception("Inserting coordinates failed");
  //         }
  //       }
  //       if(value.photos.isNotEmpty) {
  //         final batch = txn.batch();
  //         for (var photo in value.photos) {
  //           batch.insert(PhotoFields.container, photo.toMap());
  //         }
  //         final result = await batch.commit(noResult: false);
  //         if(result.isEmpty) {
  //           throw Exception("Inserting photos failed");
  //         }
  //       }
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<List<ActivityRecord>> getActivityRecords() async {
  //   final db = await _dbFuture;
  //   final maps = await db.query(ActivityRecordFields.container);
  //   return maps.map((map) {
  //     return ActivityRecord.fromMap(map);
  //   }).toList();
  // }

  // Future<ActivityRecord?> getActivityRecord(String id) async {
  //   final db = await _dbFuture;
  //   final maps = await db.query(ActivityRecordFields.container,
  //       where: "${ActivityRecordFields.id} = ?", whereArgs: [id]);
  //   return maps.isEmpty ? null : ActivityRecord.fromMap(maps.first);
  // }

  // Future<bool> updateRecord(ActivityRecord record) async {
  //   final db = await _getDatabase();
  //   try {
  //     final changes = await db.update(
  //       ActivityRecordRepoConst.container,
  //       record.toMap(),
  //       where: "${ActivityRecordRepoConst.id} = ?",
  //       whereArgs: [record.id],
  //     );
  //     print("Updating activity record => $changes change(s)");
  //     return changes > 0;
  //   } catch(e) {
  //     print("Error updating activity record => $e");
  //     return false;
  //   }
  // }

  // Future<bool> deleteRecord(String id) async {
  //   final db = await _getDatabase();
  //   try {
  //     final changes = await db.delete(
  //       ActivityRecordRepoConst.container,
  //       where: "${ActivityRecordRepoConst.id} = ?",
  //       whereArgs: [id],
  //     );
  //     print("Deleting activity record => $changes change(s)");
  //     return changes > 0;
  //   } catch (e) {
  //     print("Error deleting activity record => $e");
  //     return false;
  //   }
  // }
}
