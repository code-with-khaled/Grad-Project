import 'package:grad_project/features/auth/models/user.dart';

class LoginRequestDto {
  final String phoneNumber;
  final String password;

  LoginRequestDto({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "password": password,
  };
}

class LoginResponseDto {
  final String token;
  final String refreshToken;
  final int repId;
  final User user;

  LoginResponseDto({
    required this.token,
    required this.refreshToken,
    required this.repId,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    final user = User(
      id: data['userId'],
      name: data['name'],
      phone: data['phoneNumber'],
      role: data['role'],
    );

    return LoginResponseDto(
      token: data["accessToken"],
      refreshToken: data["refreshToken"],
      repId: data["userId"],
      user: user,
    );
  }
}
