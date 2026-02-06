import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class ChangePasswordUseCase {
  final IUserRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call() {
    return repository.changePassword();
  }
}
