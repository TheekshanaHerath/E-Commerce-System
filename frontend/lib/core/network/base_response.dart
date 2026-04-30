class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? code;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });
}