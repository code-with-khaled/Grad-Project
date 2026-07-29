class LoginRequestDto {
  final String username;
  final String password;

  LoginRequestDto({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
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
    return LoginResponseDto(
      token: json["token"],
      refreshToken: json["refreshToken"],
      repId: json["repId"],
    );
  }
}
