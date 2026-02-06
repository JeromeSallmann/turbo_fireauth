import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class SendPasswordResetEmail {
  final IUserRepository repository;

  SendPasswordResetEmail(this.repository);

  Future<void> call(String email) async {
    await repository.sendPasswordResetEmail(email);
  }
}
