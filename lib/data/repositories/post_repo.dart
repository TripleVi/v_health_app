// import '../../domain/entities/comment.dart';
// import '../../domain/entities/map.dart';
// import '../../domain/entities/post.dart';
// import '../../domain/entities/reaction.dart';
// import '../sources/firestore/dao/post_firestore.dart';
// import '../sources/sqlite/dao/post_sqlite.dart';

// class PostRepo {
//   final PostSqlite _postSqlite;
//   final PostFirestore _postFirestore;

//   PostRepo(this._postSqlite, this._postFirestore);

//   Future<void> insertPost(Post value) {
//     return _postFirestore.insertPost(value);
//   }

//   Stream<List<Post>> getPosts() {
//     return _postFirestore.getPosts();
//   }

//   Future<Post> getPostDetails(String postId) {
//     return _postFirestore.getPostDetails(postId);
//   }

//   Stream<List<Reaction>> getPostReactions(String postId) {
//     return _postFirestore.getPostReactions(postId);
//   }

//   Future<void> insertPostReaction(String postId, Reaction reaction) {
//     return _postFirestore.insertPostReaction(postId, reaction);
//   }

//   Future<void> deletePostReaction(String postId, String userId) {
//     return _postFirestore.deletePostReaction(postId, userId);
//   }

//   Stream<List<Comment>> getPostComments({
//     required String postId, 
//     String? parentId,
//     required int limit,
//   }) {
//     return _postFirestore.getPostComments(
//       postId: postId, 
//       parentId: parentId,
//       limit: limit,
//     );
//   }

//   Future<void> insertPostComment(String postId, Comment comment) {
//     return _postFirestore.insertPostComment(postId, comment);
//   }

//   Future<void> deletePostComment({
//     required String postId, 
//     required String commentId,
//   }) {
//     return _postFirestore.deletePostComment(
//       postId: postId,
//       commentId: commentId,
//     );
//   }

//   Future<int> countPostLikes(String postId) {
//     return _postFirestore.countPostLikes(postId);
//   }

//   Future<int> countPostComments(String postId) {
//     return _postFirestore.countPostComments(postId);
//   }

//   Future<int> countPostSubComments({
//     required String postId,
//     String? parentId,
//   }) {
//     return _postFirestore.countPostSubComments(
//       postId: postId,
//       parentId: parentId,
//     );
//   }

//   Future<bool> isPostLiked({
//     required String postId,
//     required String userId,
//   }) {
//     return _postFirestore.isPostLiked(postId: postId, userId: userId);
//   }

//   Future<MapData> getMapDetails(String postId) {
//     return _postFirestore.getMapDetails(postId);
//   }
// }