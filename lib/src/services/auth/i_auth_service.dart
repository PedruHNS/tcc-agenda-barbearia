import 'package:barbershop_schedule/src/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class IAuthService {
  Future<String> login(String email, String password);
  Future<User> getUser();
  Future<void> logout();
  Future<void> register(AuthModel client);
  Future<void> forgotPassword(String email);
}
