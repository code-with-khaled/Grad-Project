import 'package:grad_project/core/storage/token_storage.dart';
import 'auth_api_service.dart';
import 'auth_dto.dart';

class AuthRepository {
  final AuthApiService _api;
  final TokenStorage _storage;

  AuthRepository(this._api, this._storage);

  Future<bool> login(String username, String password) async {
    final dto = LoginRequestDto(username: username, password: password);

    final result = await _api.login(dto);

    await _storage.saveToken(result.token);
    await _storage.saveRefreshToken(result.refreshToken);
    await _storage.saveRepId(result.repId);

    return true;
  }

  Future<void> logout() async {
    await _api.logout();
    await _storage.clear();
  }

  Future<void> refresh() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return;

    final newToken = await _api.refreshToken(refreshToken);
    await _storage.saveToken(newToken);
  }
}
