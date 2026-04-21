import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../api/network_exception.dart';
import '../api/token_manager.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final String baseUrl = "http://54.80.220.45:8080";

  Future<LoginResponse> login(String email, String password) async {
    final client = ApiService.getClient();

    final url = Uri.parse("$baseUrl/api/v1/auth/login");

    final response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final body = jsonDecode(response.body);
    final message = body['message'] ?? "Something went wrong";
    final errorCode = body['code'];

    // ✅ SUCCESS
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(body);
    }

    if (response.statusCode == 401) {
      if (errorCode == 'token_not_valid') {
        TokenManager.handleTokenExpired();

        throw NetworkException(
          message: "Session expired. Please log in again.",
          statusCode: 401,
          errorCode: errorCode,
        );
      }
      if (errorCode == 'INVALID_CREDENTIALS') {
        throw NetworkException(
          message: message, // "Invalid credentials"
          statusCode: 401,
          errorCode: errorCode,
        );
      }

      throw NetworkException(
        message: message,
        statusCode: 401,
        errorCode: errorCode,
      );
    }

    // ❌ OTHER ERRORS
    throw NetworkException(
      message: message,
      statusCode: response.statusCode,
      errorCode: errorCode,
    );
  }
}