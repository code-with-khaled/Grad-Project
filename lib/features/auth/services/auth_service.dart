class AuthService {
  Future<Map<String, dynamic>> login(String phone, String password) async {
    // Implement your login logic here
    // For example, make an API call to authenticate the user
    // Return a map containing user data and authentication token

    await Future.delayed(Duration(seconds: 2)); // Simulating network delay

    // Mock Response
    return {
      'access_token': 'dummy_token_123',
      'refresh_token': 'dummy_refresh_token_456',
      'user': {'id': 1, 'name': 'Khaled', 'phone': phone, 'role': 'rep'},
    };
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    // Implement your token refresh logic here
    // For example, make an API call to refresh the access token
    // Return a map containing the new access token and user data

    await Future.delayed(Duration(seconds: 1)); // Simulating network delay

    // Mock Response
    return {
      'access_token': 'new_dummy_token_789',
      'refresh_token': refreshToken,
    };
  }
}
