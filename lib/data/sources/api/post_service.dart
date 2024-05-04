import "dart:convert";

import "package:dio/dio.dart";
import "package:http_parser/http_parser.dart";
import "package:mime/mime.dart" as mime;

import "../../../core/services/shared_pref_service.dart";
import "../../../domain/entities/activity_record.dart";
import "../../../domain/entities/comment.dart";
import "../../../domain/entities/coordinate.dart";
import "../../../domain/entities/photo.dart";
import "../../../domain/entities/post.dart";
import "../../../domain/entities/reaction.dart";
import "../../../domain/entities/user.dart";
import "../../../domain/entities/workout_data.dart";
import "../../../presentation/activity_tracking/bloc/activity_tracking_bloc.dart";
import "dio_service.dart";

class MapData {
  List<Coordinate> coordinates;
  List<Photo> photos;

  MapData({
    required this.coordinates,
    required this.photos,
  });
} 

class PostService {
  Future<List<Post>> fetchPosts() async {
    try {
      final currentUser = await SharedPrefService.getCurrentUser();
      final response = await DioService.instance.dio.get<List>(
        "/posts",
        options: Options(
          headers: {
            "uid": currentUser.uid,
            "username": currentUser.username,
          },
        ),
      );
      return response.data!.map((e) {
        final user = User.empty()
        ..uid = e["author"]["uid"]
        ..username = e["author"]["username"]
        ..name = e["author"]["name"]
        ..avatarUrl = e["author"]["avatarUrl"];
        final post = Post.fromMap(e)
        ..author = user
        ..record = ActivityRecord.fromMap(e["record"]);
        return post;
      }).toList();
    } on DioException {
      return const [];
    }
  }

  Future<MapData?> fetchPostMap(String postId) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.get<Map<String, dynamic>>(
      "/posts/$postId/map",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    if(response.statusCode != 200) return null;
    final coordinates = (response.data!["coordinates"] as List)
        .map((e) => Coordinate.fromMap(e))
        .toList(growable: false);
    final photos = (response.data!["photos"] as List)
        .map((e) => Photo.fromMap(e))
        .toList(growable: false);
    return MapData(coordinates: coordinates, photos: photos);
  }

  Future<Post?> fetchPostDetails(String postId) async {
    try {
      final currentUser = await SharedPrefService.getCurrentUser();
      final response = await DioService.instance.dio.get<Map<String, dynamic>>(
        "/posts/$postId",
        options: Options(
          headers: {
            "uid": currentUser.uid,
            "username": currentUser.username,
          },
        ),
      );
      final post = Post.empty();
      if(response.data!["coordinates"] != null) {
        post.record.coordinates = (response.data!["coordinates"] as List)
            .map((e) => Coordinate.fromMap(e)).toList();
      }
      if(response.data!["photos"] != null) {
        post.record.photos = (response.data!["photos"] as List)
            .map((e) => Photo.fromMap(e)).toList();
      }
      post.record.data = (response.data!["data"] as List)
          .map((e) => WorkoutData.fromMap(e)).toList();
      return post;
    } on DioException {
      return null;
    }
  }
  
  Future<Post?> createPost(Post post) async {
    try {
      final postMap = post.toMap();
      postMap["record"] = post.record.toMap();
      postMap["record"]["coordinates"] = post
          .record.coordinates.map((e) => e.toMap()).toList(growable: false);
      postMap["record"]["data"] = post
          .record.data.map((e) => e.toMap()).toList(growable: false);
      final currentUser = await SharedPrefService.getCurrentUser();
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
    final currentUser = await SharedPrefService.getCurrentUser();
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
    final currentUser = await SharedPrefService.getCurrentUser();
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
    final currentUser = await SharedPrefService.getCurrentUser();
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
    final currentUser = await SharedPrefService.getCurrentUser();
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

  Future<List<Reaction>> fetchUserReactions(String postId) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.get<List<dynamic>>(
      "/posts/$postId/reactions",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.statusCode == 200 
        ? response.data!.map((e) => Reaction.fromMap(e)).toList(growable: false)
        : const [];
  }

  Future<int> countComments(String postId, [String? path]) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final queryParameters = path == null ? null : {"path": path};
    final response = await DioService.instance.dio.get<Map<String, dynamic>>(
      "/posts/$postId/comments/count",
      queryParameters: queryParameters,
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

  Future<int> countIndependentComments(String postId) async {
    return countComments(postId, '');
  }

  Future<List<Comment>> fetchComments({
    required String postId,
    String? path,
    DateTime? lessThanDate,
  }) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final queryParameters = <String, dynamic>{};
    if(path != null) {
      queryParameters["path"] = path;
    }
    if(lessThanDate != null) {
      queryParameters["lessThanDate"] = lessThanDate.millisecondsSinceEpoch;
    }
    final response = await DioService.instance.dio.get<List<dynamic>>(
      "/posts/$postId/comments",
      queryParameters: queryParameters,
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.statusCode == 200 
        ? response.data!.map((e) {
          final comment = Comment.fromMap(e)
          ..author.username = e["author"]["username"]
          ..author.avatarUrl = e["author"]["avatarUrl"];
          return comment;
        }).toList(growable: false)
        : const [];
  }

  Future<Comment?> createComment(Comment comment, String postId) async {
    final map = comment.toMap();
    if(comment.replyTo != null) {
      map["replyTo"] = <String, dynamic>{
        "cid": comment.replyTo!.id,
        "path": comment.replyTo!.path,
      };
    }
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.post<Map<String, dynamic>>(
      "/posts/$postId/comments",
      data: map,
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.statusCode == 201 ? Comment.fromMap(response.data!) : null;
  }

  Future<bool> deleteComment(String commentId) async {
    final currentUser = await SharedPrefService.getCurrentUser();
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