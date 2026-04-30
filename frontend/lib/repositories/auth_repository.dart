import '../../../../core/network/base_response.dart';
import '../core/result/result.dart';
import '../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../features/authentication/domain/entities/user.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Result<User>> signUp(User user) {
    return remote.signUp(user);
  }
}