import 'package:dio/dio.dart';
import 'package:ecommerce_frontend/service/token_storage.dart';

import '../core/error/network_failure.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage storage;

  ApiClient(this.dio, this.storage) {
    dio.options = BaseOptions(
      baseUrl: "http://localhost:8080",
      validateStatus: (status) => status != null && status < 500,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          options.headers["Accept-Language"] = "en";

          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw NetworkFailure(
        message: e.response?.data["message"] ?? "Network error",
        code: e.response?.data["code"],
      );
    }
  }
}