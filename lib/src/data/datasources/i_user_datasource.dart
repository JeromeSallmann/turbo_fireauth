import 'package:firebase_auth/firebase_auth.dart';
import 'package:turbo_fireauth/src/domain/models/login_result.dart';
import 'package:turbo_fireauth/src/domain/models/login_type.dart';

abstract class IUserDatasource {
  Future<User?> getCurrentUser();
  Future<LoginResult> loginWithProvider(AuthProvider provider);
  Future<LoginResult> loginWithEmailPwd(EmailLogin loginType);
  Future<LoginResult> createUserWithEmailPwd(EmailCreate loginType);
  Future<LoginResult?> register(String user, String pwd);
  Future<String?> getUserIdToken({bool forceRefresh = false});
  Future<void> logout();
  Future<void> sendPasswordResetMail(String email);
  Future<void> updateProfile({String? displayName});
  Future<void> changePassword();
  Future<LoginResult> loginWithGoogleSignin();
}
