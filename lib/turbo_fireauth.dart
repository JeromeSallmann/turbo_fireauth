// lib/turbo_fireauth_impl.dart

/// Une librairie légère pour simplifier l'authentification Firebase et Google Sign-In
/// suivant les principes de la Clean Architecture.
///
/// Pour commencer, utilisez la classe [TurboFireAuth] :
/// ```dart
/// final auth = TurboFireAuth.instance;
/// await auth.init();
/// ```
// ignore: unnecessary_library_name
library turbo_fireauth;

export 'src/turbo_fireauth_impl.dart' show TurboFireAuth;
export 'src/domain/models/login_result.dart';
export 'src/domain/models/login_type.dart';
export 'src/domain/models/google_signin_config.dart';
export 'package:firebase_auth/firebase_auth.dart' show User, AuthCredential;
