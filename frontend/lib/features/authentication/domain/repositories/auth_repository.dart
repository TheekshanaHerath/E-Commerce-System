import '../../domain/entities/user.dart';
import '../../../../core/result/result.dart';

abstract class AuthRepository {
  Future<Result<User>> signUp(User user);
}