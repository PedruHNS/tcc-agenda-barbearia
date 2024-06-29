import 'package:barbershop_schedule/src/core/failures/login_failure.dart';
import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';

import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final IAuthService authService;
  String? errorMessage;
  String? _userCredential;
  var loading = false;

  String? get userCredential => _userCredential;

  LoginController({required this.authService});

  Future<void> login(String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      _userCredential = await authService.login(email, password);

      loading = false;
      notifyListeners();
    } on LoginFailure catch (e) {
      loading = false;
      errorMessage = e.message;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    await authService.forgotPassword(email);
  }
}
