import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grad_project/features/auth/data/auth_repository.dart';
// import 'package:grad_project/features/auth/services/auth_service.dart';

// class AuthProvider extends ChangeNotifier {
//   final AuthService authService;
//   final FlutterSecureStorage secureStorage = FlutterSecureStorage();

//   bool isLoading = false;
//   String? error;
//   String? accessToken;
//   String? refreshToken;

//   AuthProvider({required this.authService});

//   Future<void> login(String phone, String password) async {
//     isLoading = true;
//     error = null;
//     notifyListeners();

//     try {
//       final result = await authService.login(phone, password);
//       accessToken = result['access_token'];
//       refreshToken = result['refresh_token'];

//       // ignore: avoid_print
//       print('Access Token: $accessToken');
//       // ignore: avoid_print
//       print('Refresh Token: $refreshToken');

//       secureStorage.write(key: "access_token", value: accessToken);
//       secureStorage.write(key: "refresh_token", value: refreshToken);

//       isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       isLoading = false;
//       error = "Login failed: ${e.toString()}";
//       notifyListeners();
//     }
//   }

//   Future<bool> tryAutoLogin() async {
//     accessToken = await secureStorage.read(key: "access_token");
//     refreshToken = await secureStorage.read(key: "refresh_token");

//     return accessToken != null;
//   }

//   Future<void> logout() async {
//     await secureStorage.deleteAll();
//     accessToken = null;
//     refreshToken = null;
//     notifyListeners();
//   }
// }

class AuthProvider extends ChangeNotifier {
  final AuthRepository repo;

  bool isLoading = false;
  String? error;

  AuthProvider({required this.repo});

  Future<bool> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final success = await repo.login(username, password);

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      error = "Login failed: $e";
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await repo.logout();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final token = await repo.getToken();
    return token != null;
  }
}
