class ApiError {
  final String message;
  final int? statusCode;

  ApiError({required this.message, this.statusCode});
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? 'Something went wrong',
      statusCode: json['statusCode'],
    );
  }
}
