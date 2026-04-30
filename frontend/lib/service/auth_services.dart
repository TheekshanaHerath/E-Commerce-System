import '../model/signUp_request_model.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient api;

  AuthService(this.api);

  Future<Map<String, dynamic>> signUp(SignUpRequestModel user) {
    return api.post("/api/v1/auth/register", user.toJson());
  }
}