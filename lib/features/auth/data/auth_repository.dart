import 'package:dio/dio.dart';
import 'package:grad_project/core/network/error_handler.dart';
import 'package:grad_project/core/storage/token_storage.dart';
import 'package:grad_project/features/auth/models/login_result.dart';
import 'auth_api_service.dart';
import 'auth_dto.dart';

class AuthRepository {
  final AuthApiService _api;
  final TokenStorage _storage;

  AuthRepository(this._api, this._storage);

  Future<LoginResult> login(String username, String password) async {
    try {
      final dto = LoginRequestDto(phoneNumber: username, password: password);
      final result = await _api.login(dto);

      await _storage.saveToken(result.token);
      await _storage.saveRefreshToken(result.refreshToken);
      await _storage.saveRepId(result.repId);

      return LoginResult(
        token: result.token,
        refreshToken: result.refreshToken,
        repId: result.repId,
        user: result.user,
      );
    } catch (e) {
      if (e is DioException) {
        throw ErrorHandler.parse(e);
      }
      throw "Unexpected error";
    }
  }

  Future<void> logout() async {
    await _api.logout();
    await _storage.clear();
  }

  Future<String?> getToken() async {
    return _storage.getToken();
  }

  Future<void> refresh() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return;

    final newToken = await _api.refreshToken(refreshToken);
    await _storage.saveToken(newToken);
  }
}
