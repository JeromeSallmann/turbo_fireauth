import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class UpdateProfileUseCase {
  final IUserRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<void> call({String? displayName}) {
    return _repository.updateProfile(displayName: displayName);
  }
}
