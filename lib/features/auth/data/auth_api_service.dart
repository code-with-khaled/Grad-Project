// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'auth_dto.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    final response = await _dio.post(Endpoints.login, data: dto.toJson());

    print(response.data);

    return LoginResponseDto.fromJson(response.data);
  }

  Future<void> logout() async {
    final response = await _dio.post(Endpoints.logout);
    print(response.data);
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      Endpoints.refresh,
      data: {"refreshToken": refreshToken},
    );

    return response.data["token"];
  }
}
