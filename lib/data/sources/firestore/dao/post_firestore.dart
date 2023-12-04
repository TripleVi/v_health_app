// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../../domain/entities/comment.dart';
// import '../../../../domain/entities/coordinate.dart';
// import '../../../../domain/entities/map.dart';
// import '../../../../domain/entities/photo.dart';
// import '../../../../domain/entities/post.dart';
// import '../../../../domain/entities/reaction.dart';
// import '../../../../domain/entities/workout_data.dart';

// class PostFirestore {
//   final _db = FirebaseFirestore.instance;
//   Future<void> insertPost(Post post) async {
//     final batch = _db.batch();
//     final postMap = post.toFirestore()
//     ..["activityRecord"] = post.activityRecord!.toMap();
//     final postRef = _db.collection("posts").doc(post.id);
//     batch.set(postRef, postMap);
//     final coordinates = post.activityRecord!.coordinates;
//     final coordinatesRef = postRef.collection("coordinates");
//     for(var c in coordinates) {
//       batch.set(coordinatesRef.doc(c.id), c.toFirestore());
//     }
//     final photosRef = postRef.collection("photos");
//     final photos = post.activityRecord!.photos;
//     for(var p in photos) {
//       batch.set(photosRef.doc(p.id), p.toFirestore());
//     }
//     final data = post.activityRecord!.data;
//     final dataRef = postRef.collection("data");
//     for(var d in data) {
//       batch.set(dataRef.doc(d.id), d.toFirestore());
//     }
//     await batch.commit();
//   }

//   Stream<List<Post>> getPosts() {
//     return _db
//       .collection("posts")
//       .snapshots()
//       .map((event) {
//         return event.docs
//           .map((e) => Post.fromFirestore(e.data()))
//           .toList();
//       });
//   }

//   Stream<List<Reaction>> getPostReactions(String postId) {
//     return _db
//       .collection("posts/$postId/reactions")
//       .snapshots()
//       .map((querySnap) 
//           => querySnap.docs.map((docSnap) 
//               => Reaction.fromFirestore(docSnap.data()))
//           .toList());
//   }

//   Future<void> insertPostReaction(String postId, Reaction reaction) {
//     return _db
//       .doc("posts/$postId/reactions/${reaction.userId}")
//       .set(reaction.toFirestore());
//   }

//   Future<void> deletePostReaction(String postId, String userId) {
//     return _db
//       .doc("posts/$postId/reactions/$userId")
//       .delete();
//   }

//   Stream<List<Comment>> getPostComments({
//     required String postId,
//     String? parentId,
//     required int limit,
//   }) {
//     final commentsRef = _db.collection("posts/$postId/comments");
//     final Query<Map<String, dynamic>> query;
//     query = parentId == null 
//         ? commentsRef.where("parentId", isNull: true)
//         : commentsRef.where("parentId", isEqualTo: parentId);
//     return query
//       .orderBy("createdAt", descending: true)
//       .limit(limit)
//       .snapshots(includeMetadataChanges: true)
//       .map((querySnap) {
//         final comments = <Comment>[];
//         for (var docSnap in querySnap.docs) {
//           if(!docSnap.metadata.hasPendingWrites) {
//             comments.add(Comment.fromFirestore(docSnap.data()));
//           }
//         }
//         return comments;
//       });
//   }

//   Future<int> countPostSubComments({
//     required String postId,
//     String? parentId,
//   }) async {
//     final commentsRef = FirebaseFirestore.instance.collection("posts/$postId/comments");
//     final Query<Map<String, dynamic>> query;
//     query = parentId == null 
//         ? commentsRef.where("parentId", isNull: true)
//         : commentsRef.where("parentId", isEqualTo: parentId);
//     final aggregateQuerySnap = await query.count().get();
//     return aggregateQuerySnap.count;
//   }

//   Future<int> countPostLikes(String postId) async {
//     final aggregateQuerySnap = await FirebaseFirestore.instance
//       .collection("posts/$postId/reactions")
//       .count()
//       .get();
//     return aggregateQuerySnap.count;
//   }

//   Future<int> countPostComments(String postId) async {
//     final aggregateQuerySnap = await FirebaseFirestore.instance
//       .collection("posts/$postId/comments")
//       .count()
//       .get();
//     return aggregateQuerySnap.count;
//   }

//   Future<bool> isPostLiked({
//     required String postId,
//     required String userId,
//   }) async {
//     final docSnap = await FirebaseFirestore.instance
//       .doc("posts/$postId/reactions/$userId")
//       .get();
//     return docSnap.exists;
//   }

//   Future<void> insertPostComment(String postId, Comment comment) {
//     return _db
//       .doc("posts/$postId/comments/${comment.id}")
//       .set(comment.toFirestore());
//   }

//   Future<void> deletePostComment({
//     required String postId, 
//     required String commentId,
//   }) async {
//     final commentRef = _db.doc("posts/$postId/comments/$commentId");
//     await commentRef.delete();
//     final subComments = await commentRef.parent
//       .where("parentId", isEqualTo: commentId)
//       .get();

//     for(var c in subComments.docs) {
//       await deletePostComment(postId: postId, commentId: c.id);
//     }
//   }

//   Future<Post> getPostDetails(String postId) async {
//     final docSnap = await _db
//       .doc("posts/$postId")
//       .get();

//     if(!docSnap.exists) {
//       throw Exception("Post (id: $postId) does not exist");
//     }
//     final post = Post.fromFirestore(docSnap.data()!);

//     final querySnap = await _db
//       .collection("posts/$postId/events")
//       .get();

//     post.activityRecord!.data = querySnap.docs.map((q) {
//       return WorkoutData.fromFirestore(q.data());
//     }).toList();

//     return post;
//   }

//   Future<MapData> getMapDetails(String postId) async {
//     final docSnap = await _db
//       .doc("posts/$postId")
//       .get();

//     if(!docSnap.exists) {
//       throw Exception("Post (id: $postId) does not exist");
//     }

//     final coordinatesQuery = await _db
//       .collection("posts/$postId/coordinates")
//       .orderBy("time_frame", descending: false)
//       .get();

//     final photosQuery = await _db
//       .collection("posts/$postId/photos")
//       .get();

//     final data = MapData()
//     ..coordinates = coordinatesQuery.docs.map((q) {
//       return Coordinate.fromFirestore(q.data());
//     }).toList()
//     ..photos = photosQuery.docs.map((p) {
//       return Photo.fromFirestore(p.data());
//     }).toList();

//     return data;
//   }

//   static Future<String> pushFollower() async {
//     final db = FirebaseFirestore.instance;
//     await db.doc("users/65520fbb-0214-4d82-8067-c71e1ff23008/followers/f778febc-c4c5-44df-897d-1cc6c18bdae6").set({
//       "avatarUrl": "123",
//       "username": "vuongvu",
//     });
//     return "hello world";
//   }
// }