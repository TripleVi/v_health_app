import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/activity_record.dart';
import '../../../../domain/entities/coordinate.dart';
import '../../../../domain/entities/photo.dart';
import '../../../../domain/entities/post.dart';
import '../../table_attributes.dart';

class PostSqlite {
  final Future<Database> _dbFuture;

  PostSqlite(this._dbFuture);

  // Future<void> insertPost(Post value) async {
  //   final db = await _dbFuture;
  //   await db.transaction<void>((txn) async {
  //     var changes = await txn.insert(PostFields.container, value.toSqlite());
  //     if(changes != 1) {
  //       throw Exception("Inserting post failed");
  //     }
  //     changes = await txn.insert(
  //       ActivityRecordFields.container, 
  //       value.activityRecord!.toMap(),
  //     );
  //     if(changes != 1) {
  //       throw Exception("Inserting activity record failed");
  //     }
  //     final coordinates = value.activityRecord!.coordinates;
  //     if(coordinates.isNotEmpty) {
  //       final batch = txn.batch();
  //       for (var coordinate in coordinates) {
  //         batch.insert(CoordinateFields.container, coordinate.toMap());
  //       }
  //       // final result = await batch.commit(noResult: false);
  //       // if(result.isEmpty) {
  //       //   throw Exception("Inserting coordinates failed");
  //       // }
  //     }
  //     final photos = value.activityRecord!.photos;
  //     if(photos.isNotEmpty) {
  //       final batch = txn.batch();
  //       for (var photo in photos) {
  //         batch.insert(PhotoFields.container, photo.toMap());
  //       }
  //       // final result = await batch.commit(noResult: false);
  //       // if(result.isEmpty) {
  //       //   throw Exception("Inserting photos failed");
  //       // }
  //     }
  //   });
  // }

  // Future<List<Post>> getPosts() async {
  //   final db = await _dbFuture;
  //   const sql = "SELECT * FROM ${PostFields.container} t1 "
  //       "INNER JOIN ${ActivityRecordFields.container} t2 "
  //       "ON t2.${ActivityRecordFields.id} = t1.${PostFields.recordId}";
  //   final maps = await db.rawQuery(sql);
  //   return maps.map((map) {
  //     final post = Post.fromSqlite(map)
  //     ..activityRecord = ActivityRecord.fromMap(map);
  //     return post;
  //   }).toList();
  // }

  // Future<Post?> getPostDetail(String postId) async {
  //   final db = await _dbFuture;
  //   const query = "SELECT * FROM ${PostFields.container} t1 "
  //     "INNER JOIN ${ActivityRecordFields.container} t2 "
  //     "ON t2.${ActivityRecordFields.id} = t1.${PostFields.recordId}"
  //     "WHERE t1.${PostFields.id} = ?";
  //   final postMaps = await db.rawQuery(query, [postId]);
  //   if(postMaps.length != 1) {
  //     return null;
  //   }
  //   final post = Post.fromSqlite(postMaps.first)
  //   ..activityRecord = ActivityRecord.fromMap(postMaps.first);
  //   final coordinateMaps = await db.query(
  //     CoordinateFields.container,
  //     where: "${CoordinateFields.recordId} = ?",
  //     whereArgs: [post.recordId],
  //   );
  //   final coordinates = coordinateMaps
  //       .map((map) => Coordinate.fromMap(map))
  //       .toList();
  //   post.activityRecord!.coordinates = coordinates;
  //   final photoMaps = await db.query(
  //     PhotoFields.container,
  //     where: "${PhotoFields.recordId} = ?",
  //     whereArgs: [post.recordId],
  //   );
  //   final photos = photoMaps
  //       .map((map) => Photo.fromMap(map))
  //       .toList();
  //   post.activityRecord!.photos = photos;
  //   return post;
  // }
}
