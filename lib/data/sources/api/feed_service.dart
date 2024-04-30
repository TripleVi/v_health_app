import "dart:convert";

import "package:dio/dio.dart";

import "../../../core/services/shared_pref_service.dart";
import "../../../domain/entities/activity_record.dart";
import "../../../domain/entities/post.dart";
import "../../../domain/entities/user.dart";
import "dio_service.dart";

class FeedService {
  Future<List<String>> fetchNewsFeed(List<String> viewedPostIds) async {
    try {
      final currentUser = await SharedPrefService.getCurrentUser();
      final response = await DioService.instance.dio.get<Map>(
        "/feed",
        options: Options(
          headers: {
            "uid": "123456",
            // "uid": currentUser.uid,
            "username": currentUser.username,
          },
        ),
        data: {"viewedPostIds": viewedPostIds},
      );
      return (response.data!["postIds"]! as List)
          .map((e) => e.toString()).toList();
    } on DioException catch (e) {
      print(e);
      return const [];
    }
  }

  Future<List<Post>> fetchPostsByIds(List<String> ids) async {
    if(ids.isEmpty) return [];
    try {
      final currentUser = await SharedPrefService.getCurrentUser();
      final response = await DioService.instance.dio.get<List>(
        "/feed/posts",
        options: Options(
          headers: {
            "uid": currentUser.uid,
            "username": currentUser.username,
          },
        ),
        queryParameters: {"ids": jsonEncode(ids)},
      );
      return response.data!.map((e) {
        final user = User.empty()
        ..uid = e["author"]["uid"]
        ..username = e["author"]["username"]
        ..firstName = e["author"]["firstName"]
        ..lastName = e["author"]["lastName"]
        ..avatarUrl = e["author"]["avatarUrl"];
        final post = Post.fromMap(e)
        ..author = user
        ..record = ActivityRecord.fromMap(e["record"]);
        return post;
      }).toList();
    } on DioException catch (e) {
      print(e);
      return const [];
    }
  }
}