import 'package:firebase_auth/firebase_auth.dart';
import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class GetCurrentUser {
  final IUserRepository repository;

  GetCurrentUser(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
