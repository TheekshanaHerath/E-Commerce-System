class UserDto {
  final String name;
  final String email;

  UserDto({
    required this.name,
    required this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}