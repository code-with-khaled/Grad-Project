import 'package:grad_project/features/auth/models/user.dart';

class LoginResult {
  final String token;
  final String refreshToken;
  final int repId;
  final User user;

  LoginResult({
    required this.token,
    required this.refreshToken,
    required this.repId,
    required this.user,
  });
}
