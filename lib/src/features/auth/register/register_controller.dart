import 'package:barbershop_schedule/src/core/failures/login_failure.dart';
import 'package:barbershop_schedule/src/models/auth_model.dart';
import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  final IAuthService authService;
  var loading = false;
  String? errorMessage;

  RegisterController(this.authService);

  Future<void> register(AuthModel client) async {
    try {
      loading = true;
      notifyListeners();
      await authService.register(client);

      loading = false;
      notifyListeners();
    } on LoginFailure catch (e) {
      loading = false;
      errorMessage = e.message;
      notifyListeners();
    }
  }
}
