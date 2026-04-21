class ApiResponse<T> {
  final bool success;
  final String message;
  final String code;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.code,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json)? fromJsonT,
      ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}