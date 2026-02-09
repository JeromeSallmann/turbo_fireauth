import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:turbo_fireauth/src/data/datasources/i_user_datasource.dart';
import 'package:turbo_fireauth/src/domain/models/login_result.dart';
import 'package:turbo_fireauth/src/domain/models/login_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDatasourceImpl implements IUserDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn? _googleSignin;
  final String? _emailVerificationCallbackUri;
  final String? _passwordResetCallbackUri;

  UserDatasourceImpl(
    this._auth,
    this._googleSignin,
    this._emailVerificationCallbackUri,
    this._passwordResetCallbackUri,
  );

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  @override
  Future<LoginResult> loginWithProvider(AuthProvider provider) async {
    try {
      if (kIsWeb) {
        // Sur Web, on teste si on est sur un mobile ou une tablette
        bool isMobileWeb = await _isMobileBrowser();

        if (isMobileWeb) {
          if (await _isAndroidBrowser()) {
            // Navigateur mobile : Redirect est plus fiable
            debugPrint("Connexion en cours avec Redirection.");
            await _auth.signInWithRedirect(provider);
            return Redirecting();
          } else {
            debugPrint("Connexion en cours avec Popup.");
            final UserCredential userCredential = await _auth.signInWithPopup(
              provider,
            );
            debugPrint(
              "Login successful. User: ${userCredential.user?.displayName}",
            );
            return Success(userCredential.user!);
          }
        } else {
          debugPrint("Connexion en cours avec Popup.");
          final UserCredential userCredential = await _auth.signInWithPopup(
            provider,
          );
          debugPrint(
            "Login successful. User: ${userCredential.user?.displayName}",
          );
          return Success(userCredential.user!);
        }
      } else {
        debugPrint("Connexion en cours avec le flux natif.");
        final UserCredential userCredential = await _auth.signInWithProvider(
          provider,
        );
        debugPrint(
          "Login successful. User: ${userCredential.user?.displayName}",
        );
        return Success(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Erreur d'authentification (Popup) : ${e.code}");
      return _getFirebaseauthErrorType(e);
    } catch (e) {
      debugPrint("Erreur inattendue : $e");
      return UnknownFailure(e.toString());
    }
  }

  @override
  Future<LoginResult> loginWithEmailPwd(EmailLogin loginType) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: loginType.email,
            password: loginType.password,
          );

      debugPrint("Login successful. User: ${userCredential.user?.displayName}");
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      debugPrint("Erreur d'authentification (Popup) : ${e.code}");
      return _getFirebaseauthErrorType(e);
    } catch (e) {
      debugPrint("Erreur inattendue : $e");
      return UnknownFailure(e.toString());
    }
  }

  @override
  Future<LoginResult> createUserWithEmailPwd(EmailCreate loginType) async {
    if (_emailVerificationCallbackUri == null) {
      return UnknownFailure("emailVerificationCallbackUri is not initialized");
    }

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: loginType.email.trim(),
            password: loginType.password,
          );

      debugPrint(
        "Creation successful. User: ${userCredential.user?.displayName}",
      );

      await userCredential.user!.sendEmailVerification(
        ActionCodeSettings(
          url: _emailVerificationCallbackUri,
          handleCodeInApp: true,
        ),
      );

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      debugPrint("Erreur d'authentification (Popup) : ${e.code}");
      return _getFirebaseauthErrorType(e);
    } catch (e) {
      debugPrint("Erreur inattendue : $e");
      return UnknownFailure(e.toString());
    }
  }

  LoginResult _getFirebaseauthErrorType(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      final email = e.email;
      final credential = e.credential;

      if (email != null && credential != null) {
        return AccountAlreadyExistDifferentProvider(email, credential);
      } else {
        return UnknownFailure("Incomplete error information.");
      }
    } else if (e.code == 'invalid-email') {
      return EmailInvalidFailure();
    } else if (e.code == 'user-not-found') {
      return UnknownUserFailure();
    } else if (e.code == 'wrong-password') {
      return WrongPasswordFailure();
    } else if (e.code == 'email-already-in-use') {
      return EmailAlreadyExistsFailure();
    } else if (e.code == 'weak-password') {
      return WeakPasswordFailure();
    } else if (e.code == 'operation-not-allowed') {
      return ProviderNotEnabledFailure();
    } else if (e.code == 'user-disabled') {
      return UserDisabledFailure();
    } else if (e.code == 'popup-closed-by-user') {
      return CancelledByUserFailure();
    } else if (e.code == 'cancelled-popup-request') {
      return PopupAlreadyOpenFailure();
    } else if (e.code == 'invalid-credential') {
      return WrongCredentials();
    } else if (e.code == 'web-storage-unsupported') {
      return WebStorageNotAllowedFailure();
    } else if (e.code == 'provider-already-linked') {
      return ProviderAlreadyLinkedFailure();
    } else if (e.code == 'requires-recent-login') {
      return MustReloginFailure();
    } else {
      debugPrint("Auth error: ${e.message}");
      return UnknownFailure(e.toString());
    }
  }

  @override
  Future<LoginResult?> register(String user, String pwd) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: user, password: pwd);

      debugPrint(
        "Creation successful. User: ${userCredential.user?.displayName}",
      );
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      debugPrint("Account creation error: ${e.code}");
      return _getFirebaseauthErrorType(e);
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return UnknownFailure(e.toString());
    }
  }

  @override
  Future<String?> getUserIdToken({bool forceRefresh = false}) async {
    final User? userToGetToken = FirebaseAuth.instance.currentUser;

    if (userToGetToken != null) {
      debugPrint('Current user: ${userToGetToken.email}');

      final String? idToken = await userToGetToken.getIdToken(forceRefresh);

      return idToken;
    } else {
      debugPrint('No current user');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendPasswordResetMail(String email) async {
    if (_passwordResetCallbackUri == null) {
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: _passwordResetCallbackUri,
        handleCodeInApp: true,
      ),
    );
  }

  @override
  Future<void> updateProfile({String? displayName}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
    }
  }

  @override
  Future<void> changePassword() async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      await sendPasswordResetMail(user.email!);
    }
  }

  @override
  Future<LoginResult> loginWithGoogleSignin() async {
    if (_googleSignin == null) {
      return GoogleSigninNotInitializedFailure();
    }

    try {
      final GoogleSignInAccount googleUser = await _googleSignin.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final dynamic authDynamic = googleAuth;
      final String? idToken = authDynamic.idToken;

      if (idToken == null) {
        return UnknownFailure("Could not retrieve Google ID Token.");
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      debugPrint("Login successful: ${userCredential.user?.displayName}");

      return Success(userCredential.user!);
    } catch (error) {
      debugPrint("Google Sign In Error: $error");
      return UnknownFailure(error.toString());
    }
  }

  Future<bool> _isMobileBrowser() async {
    if (kIsWeb) {
      return await _isIOsBrowser() || await _isAndroidBrowser();
    } else {
      return false;
    }
  }

  Future<bool> _isIOsBrowser() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    final String? userAgent = webBrowserInfo.userAgent;
    if (userAgent != null) {
      final agentToCompare = userAgent.toLowerCase();
      return agentToCompare.contains("iphone") ||
          agentToCompare.contains("ipad");
    } else {
      return false;
    }
  }

  Future<bool> _isAndroidBrowser() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    final String? userAgent = webBrowserInfo.userAgent;
    if (userAgent != null) {
      final agentToCompare = userAgent.toLowerCase();
      return agentToCompare.contains("android");
    } else {
      return false;
    }
  }
}
