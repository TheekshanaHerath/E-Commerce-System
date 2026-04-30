import 'app_exception.dart';

class NetworkFailure extends Failure {
  NetworkFailure({
    required super.message,
    super.code,
  });
}