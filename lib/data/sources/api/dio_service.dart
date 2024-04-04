import 'package:dio/dio.dart';

class DioService {
  static final DioService instance = DioService._();
  static Dio? _dio;
  
  DioService._();

  Dio get dio => _dio ??= Dio(BaseOptions(
    // baseUrl: "https://v-health.onrender.com/api/v1",
    // baseUrl: "http://10.0.2.2:3000/api/v1",
    // baseUrl: "http://192.168.1.8:3000/api/v1",
    baseUrl: "http://10.22.49.0:3000/api/v1",
    // connectTimeout: const Duration(seconds: 15),
    // receiveTimeout: const Duration(seconds: 3),
  ));
}