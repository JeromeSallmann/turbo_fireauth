// Crée une instance globale de GetIt
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_fireauth/src/data/datasources/i_user_datasource.dart';
import 'package:turbo_fireauth/src/data/datasources/user_datasource.dart';
import 'package:turbo_fireauth/src/data/repositories/user_repository_impl.dart';
import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';
import 'package:turbo_fireauth/src/domain/usecases/get_user.dart';
import 'package:turbo_fireauth/src/domain/usecases/login.dart';
import 'package:turbo_fireauth/src/domain/usecases/logout.dart';
import 'package:turbo_fireauth/src/domain/usecases/send_password_reset_email.dart';
import 'package:turbo_fireauth/src/domain/usecases/update_profile_usecase.dart';
import 'package:turbo_fireauth/src/domain/usecases/change_password_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance; // sl pour Service Locator

void init() {
  // === Datasources (DATA) ===
  // On enregistre ApiService comme un singleton "lazy" (créé à la première utilisation)
  sl.registerFactory<IUserDatasource>(
    () => UserDatasourceImpl(
      sl(),
      kIsWeb ? null : sl.get<GoogleSignIn>(),
      sl.isRegistered<String>(instanceName: 'emailVerificationCallbackUri')
          ? sl.get<String>(instanceName: 'emailVerificationCallbackUri')
          : null,
      sl.isRegistered<String>(instanceName: 'passwordResetCallbackUri')
          ? sl.get<String>(instanceName: 'passwordResetCallbackUri')
          : null,
    ),
  );

  // === Repositories (DATA) ===
  // On enregistre l'implémentation, mais on la type avec l'abstraction du domaine.
  sl.registerLazySingleton<IUserRepository>(
    () => UserRepositoryImpl(datasource: sl()),
  );

  // === Usecases (DOMAIN) ===
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
}
