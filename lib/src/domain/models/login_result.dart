import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginResult {}

class Success extends LoginResult {
  final User user;

  Success(this.user);
}

class UnknownFailure extends LoginResult {
  final String message;

  UnknownFailure(this.message);
}

class Redirecting extends LoginResult {}

class LoginCancelledFailure extends LoginResult {}

class EmailInvalidFailure extends LoginResult {}

class EmailAlreadyExistsFailure extends LoginResult {}

class WeakPasswordFailure extends LoginResult {}

class UnknownUserFailure extends LoginResult {}

class WrongPasswordFailure extends LoginResult {}

class ProviderNotEnabledFailure extends LoginResult {}

class UserDisabledFailure extends LoginResult {}

class CancelledByUserFailure extends LoginResult {}

class PopupAlreadyOpenFailure extends LoginResult {}

class WrongCredentials extends LoginResult {}

class WebStorageNotAllowedFailure extends LoginResult {}

class ProviderAlreadyLinkedFailure extends LoginResult {}

class MustReloginFailure extends LoginResult {}

class EmailNotVerifiedFailure extends LoginResult {}

class GoogleSigninNotInitializedFailure extends LoginResult {}

class AccountAlreadyExistDifferentProvider extends LoginResult {
  final String email;
  final AuthCredential credential;
  AccountAlreadyExistDifferentProvider(this.email, this.credential);
}
