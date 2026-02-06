import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class Logout {
  final IUserRepository repository;

  Logout(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
