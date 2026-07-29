import 'package:dio/dio.dart';
import 'package:grad_project/core/network/api_client.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'auth_dto.dart';

class AuthApiService {
  final Dio _dio = ApiClient.instance;

  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    final response = await _dio.post(Endpoints.login, data: dto.toJson());

    return LoginResponseDto.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post(Endpoints.logout);
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      Endpoints.refresh,
      data: {"refreshToken": refreshToken},
    );

    return response.data["token"];
  }
}
