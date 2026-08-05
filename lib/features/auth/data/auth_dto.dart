class LoginRequestDto {
  final String username;
  final String password;

  LoginRequestDto({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"email": username, "password": password};
}

class LoginResponseDto {
  final String token;
  final String refreshToken;
  final int repId;

  LoginResponseDto({
    required this.token,
    required this.refreshToken,
    required this.repId,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return LoginResponseDto(
      token: data["accessToken"],
      refreshToken: data["refreshToken"],
      repId: data["userId"],
    );
  }
}
