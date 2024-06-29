import 'package:barbershop_schedule/src/core/failures/reset_password_failure.dart';
import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';
import 'package:flutter/foundation.dart';

class ForgotPasswordController extends ChangeNotifier {
  final IAuthService authService;
  String? errorMessage;
  var loading = false;

  ForgotPasswordController({required this.authService});

  Future<void> forgotPassword(String email) async {
    try {
      loading = true;
      notifyListeners();
      await authService.forgotPassword(email);
      loading = false;
      notifyListeners();
    } on ResetPasswordFailure catch (e) {
      loading = false;
      errorMessage = e.message;
      notifyListeners();
    }
  }
}
