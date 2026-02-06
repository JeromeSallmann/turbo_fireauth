import 'package:turbo_fireauth/src/domain/models/google_signin_config.dart';
import 'package:turbo_fireauth/src/domain/models/login_result.dart';
import 'package:turbo_fireauth/src/domain/models/login_type.dart';
import 'package:turbo_fireauth/src/domain/usecases/change_password_usecase.dart';
import 'package:turbo_fireauth/src/domain/usecases/get_user.dart';
import 'package:turbo_fireauth/src/domain/usecases/login.dart';
import 'package:turbo_fireauth/src/domain/usecases/logout.dart';
import 'package:turbo_fireauth/src/domain/usecases/send_password_reset_email.dart';
import 'package:turbo_fireauth/src/domain/usecases/update_profile_usecase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'di/dependencies_injection.dart' as di;
import 'package:get_it/get_it.dart';

/// La classe principale pour gérer l'authentification.
///
/// Exemple d'utilisation :
/// ```dart
/// await TurboFireAuth.instance.initialize();
/// ```
class TurboFireAuth {
  static final TurboFireAuth instance = TurboFireAuth._internal();
  TurboFireAuth._internal();
  final GetIt sl = GetIt.instance;
  bool _isInitialized = false;

  /// Initialise la connexion avec Firebase.
  ///
  /// Le paramètre [options] est requis si vous n'avez pas configuré
  /// FlutterFire CLI globalement.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// await TurboFireAuth.instance.initialize(options: options);
  /// ```
  Future<void> initialize({
    FirebaseOptions? options,
    GoogleSigninConfig? googleSigninConfig,
    String? passwordResetCallbackUri,
    String? emailVerificationCallbackUri,
  }) async {
    if (_isInitialized) return;

    //Gestion de l'initialisation de Firebase
    await Firebase.initializeApp(options: options);

    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }

    //Gestion de l'injection des dépendances
    di.init();

    if (!sl.isRegistered<FirebaseAuth>()) {
      sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    }

    if (!sl.isRegistered<GoogleSignIn>() && googleSigninConfig != null) {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      googleSignIn.initialize(
        clientId: googleSigninConfig.clientId,
        serverClientId: googleSigninConfig.serverClientId,
        hostedDomain: googleSigninConfig.hostedDomain,
      );
      sl.registerSingleton<GoogleSignIn>(googleSignIn);
    }

    if (passwordResetCallbackUri != null &&
        !sl.isRegistered<String>(instanceName: 'passwordResetCallbackUri')) {
      sl.registerSingleton<String>(
        passwordResetCallbackUri,
        instanceName: 'passwordResetCallbackUri',
      );
    }

    if (emailVerificationCallbackUri != null &&
        !sl.isRegistered<String>(
          instanceName: 'emailVerificationCallbackUri',
        )) {
      sl.registerSingleton<String>(
        emailVerificationCallbackUri,
        instanceName: 'emailVerificationCallbackUri',
      );
    }

    _isInitialized = true;
  }

  /// Authentifie l'utilisateur avec le type de connexion spécifié.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// final result = await TurboFireAuth.instance.login(LoginType.emailPassword);
  /// ```
  Future<LoginResult> login(LoginType loginType) async {
    if (!_isInitialized) {
      throw Exception(
        "TurboFireAuth n'est pas initialisé. Appelez initialize() d'abord.",
      );
    }

    return await sl.get<Login>().call(loginType);
  }

  /// Déconnecte l'utilisateur.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// await TurboFireAuth.instance.logout();
  /// ```
  Future<void> logout() async {
    if (!_isInitialized) {
      throw Exception(
        "TurboFireAuth n'est pas initialisé. Appelez initialize() d'abord.",
      );
    }
    await sl.get<Logout>().call();
  }

  /// Met à jour le nom d'utilisateur de l'utilisateur connecté.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// await TurboFireAuth.instance.updateUserName("John Doe");
  /// ```
  Future<void> updateUserName(String newUserName) async {
    if (!_isInitialized) {
      throw Exception(
        "TurboFireAuth n'est pas initialisé. Appelez initialize() d'abord.",
      );
    }
    await sl.get<UpdateProfileUseCase>().call(displayName: newUserName);
  }

  /// Envoie un email de réinitialisation de mot de passe.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// await TurboFireAuth.instance.sendPasswordResetEmail("john.doe@example.com");
  /// ```
  Future<void> sendPasswordResetEmail(String email) async {
    if (!_isInitialized) {
      throw Exception(
        "TurboFireAuth n'est pas initialisé. Appelez initialize() d'abord.",
      );
    }
    await sl.get<SendPasswordResetEmail>().call(email);
  }

  /// Envoie un email de réinitialisation de mot de passe à l'utilisateur connecté.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// await TurboFireAuth.instance.changePassword();
  /// ```
  Future<void> changePassword() async {
    if (!_isInitialized) {
      throw Exception(
        "TurboFireAuth n'est pas initialisé. Appelez initialize() d'abord.",
      );
    }
    await sl.get<ChangePasswordUseCase>().call();
  }

  /// Récupère l'utilisateur connecté.
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// final user = await TurboFireAuth.instance.getCurrentUser();
  /// ```
  Future<User?> getCurrentUser() async {
    if (!_isInitialized) {
      throw Exception(
        "TurboFireAuth n'est pas initialisé. Appelez initialize() d'abord.",
      );
    }
    return await sl.get<GetCurrentUser>().call();
  }
}
