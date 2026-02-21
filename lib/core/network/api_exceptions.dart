import 'package:dio/dio.dart';
import 'package:egytravel_app/core/error/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    // Timeouts
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiError(message: 'Request timeout, please try again', statusCode: 408);
    }

    // No Internet
    if (error.type == DioExceptionType.unknown &&
        error.error.toString().contains('SocketException')) {
      return ApiError(message: 'No internet connection', statusCode: 0);
    }

    // Server response errors (400 - 500)
    if (error.response != null) {
      final status = error.response!.statusCode;
      final data = error.response!.data;

      switch (status) {
        case 400:
          return ApiError(message: data['message'] ?? 'Bad Request', statusCode: 400);

        case 401:
          return ApiError(message: 'Unauthorized – please login again', statusCode: 401);

        case 403:
          return ApiError(message: 'Forbidden', statusCode: 403);

        case 404:
          return ApiError(message: 'Not found', statusCode: 404);

        case 422:
        // Validation (Register: email already taken)
          return ApiError(
            message: data['errors'] != null
                ? data['errors'].values.first[0] // first validation error
                : data['message'] ?? 'Validation error',
            statusCode: 422,
          );

        case 500:
          return ApiError(message: 'Internal server error', statusCode: 500);

        default:
          return ApiError(
            message: data['message'] ?? 'Unknown server error',
            statusCode: status,
          );
      }
    }
    return ApiError(message: 'Something went wrong', statusCode: -1);
  }
}
