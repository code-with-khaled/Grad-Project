import 'package:hive/hive.dart';

class TokenStorage {
  final Box box;

  TokenStorage(this.box);

  Future<void> saveToken(String token) async => box.put("token", token);
  Future<void> saveRefreshToken(String token) async =>
      box.put("refreshToken", token);
  Future<void> saveRepId(int id) async => box.put("repId", id);

  Future<String?> getToken() async => box.get("token");
  Future<String?> getRefreshToken() async => box.get("refreshToken");
  Future<int?> getRepId() async => box.get("repId");

  Future<void> clear() async => box.clear();
}
