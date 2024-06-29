import 'dart:developer';

import 'package:barbershop_schedule/src/core/failures/login_failure.dart';
import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';
import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  final IAuthService authService;
  var islogged = false;
  var errorMessage = '';

  SplashController({required this.authService});

  Future<void> checkUserStatus() async {
    try {
      await authService.getUser();
      islogged = true;
      notifyListeners();
    } on LoginFailure catch (e) {
      errorMessage = e.message;
      log(e.message);
      notifyListeners();
    }
  }
}
