import 'package:dio/dio.dart';
import 'package:grad_project/core/network/auth_interceptor.dart';
import 'package:grad_project/core/storage/token_storage.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://hardly-garbage-tacky.ngrok-free.dev/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: "application/json",
    ),
  );

  static void init(TokenStorage storage) {
    _dio.interceptors.add(
      AuthInterceptor(
        getToken: storage.getToken,
        getRefreshToken: storage.getRefreshToken,
        saveToken: storage.saveToken,
      ),
    );
  }

  static Dio get instance => _dio;
}
