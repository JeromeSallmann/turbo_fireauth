import 'package:firebase_auth/firebase_auth.dart';
import 'package:turbo_fireauth/src/domain/models/login_result.dart';
import 'package:turbo_fireauth/src/domain/models/login_type.dart';

abstract class IUserRepository {
  Future<User?> getCurrentUser();
  Future<LoginResult> login(LoginType loginType);
  Future<LoginResult?> register(String user, String pwd);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
  Future<void> updateProfile({String? displayName});
  Future<void> changePassword();
}
