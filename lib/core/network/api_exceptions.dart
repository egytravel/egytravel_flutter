import 'package:dio/dio.dart';
import 'package:egytravel_app/core/error/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Connection timed out. Please check your internet and try again.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        if (error.response != null) {
          final status = error.response!.statusCode;
          final data = error.response!.data;

          switch (status) {
            case 400:
              return ApiError(
                message: data['message'] ?? data['error'] ?? 'Bad Request',
                statusCode: 400,
              );
            case 401:
              return ApiError(
                message: 'Unauthorized - please login again',
                statusCode: 401,
              );
            case 403:
              return ApiError(message: 'Forbidden access', statusCode: 403);
            case 404:
              return ApiError(message: 'Resource not found', statusCode: 404);
            case 422:
              return ApiError(
                message: data['errors'] != null
                    ? data['errors'].values.first[0].toString()
                    : data['message'] ?? 'Validation error',
                statusCode: 422,
              );
            case 500:
              return ApiError(message: 'Internal server error', statusCode: 500);
            default:
              return ApiError(
                message: data['message'] ?? 'Server error: $status',
                statusCode: status ?? -1,
              );
          }
        }
        return ApiError(message: 'Unexpected server response', statusCode: -1);

      case DioExceptionType.cancel:
        return ApiError(message: 'Request was cancelled', statusCode: -1);

      case DioExceptionType.connectionError:
        return ApiError(
          message: 'No internet connection or server is unreachable',
          statusCode: 0,
        );

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return ApiError(message: 'No internet connection', statusCode: 0);
        }
        return ApiError(message: 'Unexpected error: ${error.message}', statusCode: -1);

      default:
        return ApiError(message: 'Something went wrong, please try again', statusCode: -1);
    }
  }
}
