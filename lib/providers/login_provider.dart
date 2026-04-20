import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // For demo purposes, we consider any non-empty credentials as valid
    return phone.isNotEmpty && password.isNotEmpty;
  }
}
