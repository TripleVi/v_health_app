import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/photo.dart';
import '../../table_attributes.dart';

class PhotoSqlite {
  final Future<Database> _dbFuture;

  PhotoSqlite(this._dbFuture);

  // Future<bool> insertPhotos(List<Photo> photos) async {
  //   final db = await _dbFuture;
  //   final batch = db.batch();
  //   for (var photo in photos) {
  //     batch.insert(PhotoFields.container, photo.toMap());
  //   }
  //   final result = await batch.commit(noResult: false);
  //   return result.isNotEmpty;
  // }

  // Future<List<Photo>> getPhotos(String activityRecordId) async {
  //   final db = await _dbFuture;
  //   final maps = await db.query(
  //     PhotoFields.container,
  //     where: "${PhotoFields.recordId} = ?", 
  //     whereArgs: [activityRecordId],
  //   );
  //   return maps.map((map) {
  //     return Photo.fromMap(map);
  //   }).toList();
  // }

  // Future<List<Image>> getImages(int recordId) async {
  //   final db = await _getDatabase();
  //   try {
  //     final maps = await db.query(
  //       ImageRepoConst.container,
  //       where: "${ImageRepoConst.recordId} = ?",
  //       whereArgs: [recordId],
  //     );
  //     return List.generate(maps.length, (i) {
  //       print("$tag/Getting images => ${maps[i]}");
  //       return Image.fromMap(maps[i]);
  //     }, growable: false);
  //   } catch (e) {
  //     print("$tag/Error getting images => $e");
  //     return [];
  //   }
  // }

  // Future<Image?> getImage(int recordId) async {
  //   final db = await _getDatabase();
  //   try {
  //     final maps = await db.query(
  //       ImageRepoConst.container,
  //       where: "${ImageRepoConst.id} = ?",
  //       whereArgs: [recordId],
  //     );
  //     print("$tag/Getting image => ${maps.first}");
  //     return maps.isEmpty ? null : Image.fromMap(maps.first);
  //   } catch (e) {
  //     print("$tag/Error getting image => $e");
  //     return null;
  //   }
  // }

  // Future<bool> deleteImages(String recordId) async {
  //   final db = await _getDatabase();
  //   try {
  //     final changes = await db.delete(
  //       CoordinateRepoConst.container,
  //       where: "${CoordinateRepoConst.recordId} = ?",
  //       whereArgs: [recordId],
  //     );
  //     print("Deleting coordinates => $changes change(s)");
  //     return changes > 0;
  //   } catch (e) {
  //     print("Error deleting coordinates => $e");
  //     return false;
  //   }
  // }

  // Future<bool> deleteImage(String recordId) async {
  //   final db = await _getDatabase();
  //   try {
  //     final changes = await db.delete(
  //       CoordinateRepoConst.container,
  //       where: "${CoordinateRepoConst.recordId} = ?",
  //       whereArgs: [recordId],
  //     );
  //     print("Deleting coordinates => $changes change(s)");
  //     return changes > 0;
  //   } catch (e) {
  //     print("Error deleting coordinates => $e");
  //     return false;
  //   }
  // }
}
