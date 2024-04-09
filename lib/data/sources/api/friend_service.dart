import 'package:dio/dio.dart';

import '../../../core/services/shared_pref_service.dart';
import '../../../domain/entities/friend.dart';
import 'dio_service.dart';

class FriendService {

  Future<List<Friend>> fetchUsersByUsername(String username) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final queryParameters = {"username": username};
    final response = await DioService.instance.dio.get<List<dynamic>>(
      "/friends",
      queryParameters: queryParameters,
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.statusCode! == 200
        ? response.data!.map((e) => Friend.fromMap(e)).toList(growable: false)
        : const [];
  }

  Future<List<Friend>> fetchFollowings(String uid) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.get<List<dynamic>>(
      "/friends/followings/$uid",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.statusCode! == 200
        ? response.data!.map((e) => Friend.fromMap(e)).toList(growable: false)
        : const [];
  }

  Future<List<Friend>> fetchFollowers(String uid) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.get<List<dynamic>>(
      "/friends/followers/$uid",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    return response.statusCode! == 200
        ? response.data!.map((e) => Friend.fromMap(e)).toList(growable: false)
        : const [];
  }

  Future<int> countFollowings(String uid) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.get<Map<String, dynamic>>(
      "/friends/followings/$uid/count",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = {followings: 1}
    return response.statusCode! == 200 ? response.data!["followings"] : 0;
  }

  Future<int> countFollowers(String uid) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.get<Map<String, dynamic>>(
      "/friends/followers/$uid/count",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = {followers: 1}
    return response.statusCode! == 200 ? response.data!["followers"] : 0;
  }

  Future<bool> followFriend(String uid) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final data = {"uid": uid};
    final response = await DioService.instance.dio.post(
      "/friends",
      data: data,
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = OK or Created (as String)
    return response.statusCode! == 201;
  }

  Future<bool> unfollowFriend(String uid) async {
    final currentUser = await SharedPrefService.getCurrentUser();
    final response = await DioService.instance.dio.delete(
      "/friends/$uid",
      options: Options(
        headers: {
          "uid": currentUser.uid,
          "username": currentUser.username,
        },
      ),
    );
    // response.data = OK or Created (as String)
    return response.statusCode! == 201;
  }

}