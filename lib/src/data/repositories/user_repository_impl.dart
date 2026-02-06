import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_fireauth/src/data/datasources/i_user_datasource.dart';
import 'package:turbo_fireauth/src/domain/models/login_result.dart';
import 'package:turbo_fireauth/src/domain/models/login_type.dart';
import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<User?> getCurrentUser() async {
    return await datasource.getCurrentUser();
  }

  @override
  Future<LoginResult> login(LoginType loginType) async {
    final AuthProvider? provider;

    if (loginType is GoogleLogin) {
      provider = GoogleAuthProvider();
    } else if (loginType is FacebookLogin) {
      provider = FacebookAuthProvider();
    } else if (loginType is TwitterLogin) {
      provider = TwitterAuthProvider();
    } else if (loginType is AppleLogin) {
      provider = AppleAuthProvider();
    } else if (loginType is YahooLogin) {
      provider = YahooAuthProvider();
    } else if (loginType is EmailLogin || loginType is EmailCreate) {
      provider = null;
    } else {
      return UnknownFailure("LoginType \"$loginType\" inconnu");
    }

    final LoginResult result;

    if (provider != null) {
      if (!kIsWeb && provider is GoogleAuthProvider) {
        result = await datasource.loginWithGoogleSignin();
      } else {
        result = await datasource.loginWithProvider(provider);
      }
    } else if (loginType is EmailLogin) {
      result = await datasource.loginWithEmailPwd(loginType);
    } else if (loginType is EmailCreate) {
      result = await datasource.createUserWithEmailPwd(loginType);
    } else {
      result = ProviderNotEnabledFailure();
    }

    return result;
  }

  @override
  Future<LoginResult?> register(String user, String pwd) async {
    return await datasource.register(user, pwd);
  }

  @override
  Future<void> logout() async {
    await datasource.logout();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await datasource.sendPasswordResetMail(email);
  }

  @override
  Future<void> updateProfile({String? displayName}) async {
    await datasource.updateProfile(displayName: displayName);
  }

  @override
  Future<void> changePassword() async {
    await datasource.changePassword();
  }
}
