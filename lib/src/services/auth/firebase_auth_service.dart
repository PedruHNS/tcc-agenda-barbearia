import 'dart:developer';

import 'package:barbershop_schedule/src/core/failures/login_failure.dart';
import 'package:barbershop_schedule/src/core/failures/reset_password_failure.dart';
import 'package:barbershop_schedule/src/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:barbershop_schedule/src/services/auth/i_auth_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth auth;
  final FirebaseDatabase database;
  const FirebaseAuthService({required this.auth, required this.database});

  @override
  Future<User> getUser() async {
    final user = auth.currentUser;
    if (user == null) {
      throw LoginFailure(
          'Usuário não encontrado, faça login novamente ou cadastre-se');
    }
    return user;
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;

      if (user == null) {
        throw LoginFailure('Usuário não encontrado');
      }
      return user.uid;
    } on FirebaseAuthException catch (e) {
      final exception = switch (e.code) {
        'invalid-email' => LoginFailure('email inválido'),
        'user-not-found' => LoginFailure('Usuário não encontrado'),
        'wrong-password' => LoginFailure('Senha incorreta'),
        _ => LoginFailure('login ou senha incorretos'),
      };
      throw exception;
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      final exception = switch (e.code) {
        'invalid-email' => ResetPasswordFailure('email inválido'),
        'user-not-found' => ResetPasswordFailure('Usuário não encontrado'),
        _ => ResetPasswordFailure('email não encontrado'),
      };
      throw exception;
    }
  }

  @override
  Future<void> register(AuthModel client) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: client.email,
        password: client.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DatabaseReference ref = database.ref().child('clientes/${user.uid}');
        log('==> chegou aqui na hora de guardar nobanco');
        await ref.set({
          'nome': client.name,
          'data_nascimento': client.dateOfBirth,
          'celular': client.phone,
          'email': user.email,
        });
      }
    } on FirebaseAuthException catch (e) {
      final exception = switch (e.code) {
        'email-already-in-use' => LoginFailure('E-mail já cadastrado'),
        'weak-password' => LoginFailure('Senha fraca'),
        _ => LoginFailure('email ou senha invalidos'),
      };
      throw exception;
    }
  }
}
