import 'package:turbo_fireauth/src/domain/models/login_result.dart';
import 'package:turbo_fireauth/src/domain/models/login_type.dart';
import 'package:turbo_fireauth/src/domain/repositories/i_user_repository.dart';

class Login {
  final IUserRepository repository;

  Login(this.repository);

  Future<LoginResult> call(LoginType loginType) async {
    return await repository.login(loginType);
  }
}
