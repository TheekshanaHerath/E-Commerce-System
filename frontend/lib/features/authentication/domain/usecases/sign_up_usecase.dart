import '../../../../core/result/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Result<User>> call(User user) {
    return repository.signUp(user);
  }
}