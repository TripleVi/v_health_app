import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart' as mime;

import '../../../core/services/user_service.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/entities/post.dart';
import '../../../presentation/activity_tracking/bloc/activity_tracking_bloc.dart';
import 'dio_service.dart';

class PostService {

  Future<List<Post>> fetchPosts() async {
    final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.get<List<dynamic>>(
      "/posts",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.data!.map((e) => Post.fromMap(e)).toList(growable: false);
  }
  
  Future<Post?> createPost(Post post) async {
    try {
      final postMap = post.toMap();
      final recordMap = post.record.toMap();
      final coordinatesMaps = post.record.coordinates
        .map((e) => e.toMap())
        .toList(growable: false);
      final dataMaps = post.record.data
        .map((e) => e.toMap())
        .toList(growable: false);
      postMap["record"] = recordMap;
      postMap["record"]["coordinates"] = coordinatesMaps;
      postMap["record"]["data"] = dataMaps;
      final currentUser = await UserService.getCurrentUser();
      final response = await DioService.instance.dio.post<Map<String, dynamic>>(
        "/posts",
        data: postMap,
        options: Options(headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        }),
      );
      return Post.fromMap(response.data!);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> uploadPostFiles({
    required String postId,
    required List<PhotoParams> params, 
    required String mapPath,
  }) async {
    final map = <String, dynamic>{};
    if(params.isNotEmpty) {
      final coordinates = <String, dynamic>{};
      coordinates["points"] = <Map<String, dynamic>>[];
      final photoFiles = <MultipartFile>[];
      for (var p in params) {
        coordinates["points"].add({
          "latitude": p.latitude,
          "longitude": p.longitude,
        });
        final mimeType = p.file.mimeType ?? mime.lookupMimeType(p.file.path)!;
        photoFiles.add(MultipartFile.fromFileSync(
          p.file.path,
          filename: p.file.name,
          contentType: MediaType.parse(mimeType),
        ));
      }
      final coordinatesJson = json.encode(coordinates);
      map["photos"] = photoFiles;
      map["coordinates"] = coordinatesJson;
    }
    final mimeType = mime.lookupMimeType(mapPath)!;
    final mapFile = MultipartFile.fromFileSync(
      mapPath, 
      contentType: MediaType.parse(mimeType),
    );
    map["mapImg"] = mapFile;
    final formData = FormData.fromMap(map);
    final currentUser = await UserService.getCurrentUser();
    Response response = await DioService.instance.dio.post(
      "/posts/$postId/photos",
      data: formData,
      // options: Options(responseType: ResponseType.stream),
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        }
      ),
      // onSendProgress: (int sent, int total) {
      //   print('$sent $total');
      // },
    );
    print(response.data);
  }

  Future<Map<String, dynamic>> countLikes(String postId) async {
    final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.get<Map<String, dynamic>>(
      "/posts/$postId/likes",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = {likes: 3, isLiked: true}
    return response.data!;
  }

  Future<bool> likePost(String postId) async {
    final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.post(
      "/posts/$postId/likes",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = OK or Created (as String)
    return response.statusCode == 201;
  }

  Future<bool> unlikePost(String postId) async {
    final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.delete(
      "/posts/$postId/likes",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = OK or Created
    return response.statusCode == 201;
  }

  Future<int> countComments(String postId) async {
    final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.get<Map<String, dynamic>>(
      "/posts/$postId/comments",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = {comments: 3}
    return response.data!["comments"];
  }

  Future<void> createComment(Comment comment, String postId) async {
    final map = comment.toMap();
    if(comment.parent != null) {
      map["parent"] = <String, dynamic>{
        "cid": comment.parent!.id,
      };
    }
    // final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.post(
      "/posts/$postId/comments",
      data: map,
      options: Options(
        headers: {
          "uid": "123445a",
          "username": "vuongvu0611",
        },
      ),
    );
    print(response.data);
  }

  Future<bool> deleteComment(String commentId) async {
    final currentUser = await UserService.getCurrentUser();
    final response = await DioService.instance.dio.delete(
      "/comments/$commentId",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = OK or Created
    return response.statusCode == 201;
  }
}