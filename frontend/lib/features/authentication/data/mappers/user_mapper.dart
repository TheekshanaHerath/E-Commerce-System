import '../../domain/entities/user.dart';
import '../models/user_dto.dart';

class UserMapper {
  static User toDomain(UserDto dto) {
    return User(
      name: dto.name,
      email: dto.email,
    );
  }

  static UserDto toDto(User user) {
    return UserDto(
      name: user.name,
      email: user.email,
    );
  }
}