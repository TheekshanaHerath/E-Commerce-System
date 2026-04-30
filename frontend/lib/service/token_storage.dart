import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: "accessToken");
    } catch (e) {
      print("Token read error: $e");
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: "accessToken", value: token);
  }
}