import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../domain/entities/user.dart';
import 'dio_service.dart';

class UserService {

  Future<void> test() async {
    final rs = await DioService.instance.dio.post(
      "/users/upload",
      options: Options(responseType: ResponseType.stream),
    );
    // rs.data!.stream.transform<String>(unit8Transformer).listen((event) {
    //   print(event);
    // });
    print(rs.data);
  }

  String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}

    StreamTransformer<Uint8List, String> unit8Transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(String.fromCharCodes(data));
      },
    );

  Future<bool> emailExists(String email) async {
    final users = await getUsers(options: {"email": email});
    return users.isNotEmpty;
  }

  Future<User?> getUserById(String uid) async {
    try {
      final response = await DioService.instance.dio.get<Map<String, dynamic>>(
        "/users/$uid",
      );
      return User.fromMap(response.data!);
    } on DioException catch (e) {
      if(e.response!.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    final users = await getUsers(options: {"username": username});
    return users.isNotEmpty ? users[0] : null;
  }

  Future<List<User>> getUsers({Map<String, dynamic>? options}) async {
    List<User> user = [];
    try {
      final response = await DioService.instance.dio.get<List<dynamic>>(
        "/users",
        queryParameters: options,
      );
      user = response.data!.map((e) => User.fromMap(e)).toList(growable: false);
    } on DioException {
      rethrow;
    }
    return user;
  }

  void getUser2(String id) async {
    // final response = await _dio.get("/users/$id");
    // print(response.data.toString());

  //   try {
  //   Response userData = await _dio.get(_baseUrl + '/users/$id');
  //   print('User Info: ${userData.data}');
  //   user = User.fromJson(userData.data);
  // } on DioError catch (e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
  //   if (e.response != null) {
  //     print('Dio error!');
  //     print('STATUS: ${e.response?.statusCode}');
  //     print('DATA: ${e.response?.data}');
  //     print('HEADERS: ${e.response?.headers}');
  //   } else {
  //     // Error due to setting up or sending the request
  //     print('Error sending request!');
  //     print(e.message);
  //   }
  // }
  }

  Future<User?> createUser(User user) async {
    try {
      final response = await DioService.instance.dio.post<Map<String, dynamic>>(
        "/users",
        data: user.toMap(),
      );
      return User.fromMap(response.data!);
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  void uploadFile() async {
    String imagePath = "";
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        imagePath,
        filename: "upload.jpeg",
      ),
    });

    Response response = await DioService.instance.dio.post(
      '/search',
      data: formData,
      onSendProgress: (int sent, int total) {
        print('$sent $total');
      },
    );
  }
}