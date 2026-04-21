class NetworkException implements Exception {
  final String message;
  final int statusCode;
  final String? errorCode;

  NetworkException({
    required this.message,
    required this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => message;
}