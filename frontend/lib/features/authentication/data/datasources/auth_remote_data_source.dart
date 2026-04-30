import '../../../../core/error/app_exception.dart';
import '../../../../core/result/result.dart';
import '../../../../service/api_client.dart';
import '../../domain/entities/user.dart';
import '../../data/mappers/user_mapper.dart';
import '../models/user_dto.dart';

class AuthRemoteDataSource {
  final ApiClient api;

  AuthRemoteDataSource(this.api);

  Future<Result<User>> signUp(User user) async {
    try {
      final response = await api.post(
        "/api/v1/auth/register",
        {
          "name": user.name,
          "email": user.email,
        },
      );

      if (response["success"] == true) {
        final dto = UserDto.fromJson(response["data"]);
        final domain = UserMapper.toDomain(dto);

        return Success(domain);
      }

      return FailureResult(
        Failure(message: response["message"]),
      );
    } catch (e) {
      return FailureResult(
        Failure(message: e.toString()),
      );
    }
  }
}