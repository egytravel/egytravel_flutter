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
                message: _extractMessage(data),
                statusCode: 400,
              );
            case 401:
              final msg = _extractMessage(data);
              return ApiError(
                message: msg != 'Something went wrong' ? msg : 'Unauthorized - please login again',
                statusCode: 401,
              );
            case 403:
              final msg = _extractMessage(data);
              return ApiError(
                message: msg != 'Something went wrong' ? msg : 'Forbidden access',
                statusCode: 403,
              );
            case 404:
              final msg = _extractMessage(data);
              return ApiError(
                message: msg != 'Something went wrong' ? msg : 'Resource not found',
                statusCode: 404,
              );
            case 422:
              return ApiError(
                message: _extractMessage(data),
                statusCode: 422,
              );
            case 500:
              return ApiError(message: 'Internal server error', statusCode: 500);
            default:
              return ApiError(
                message: _extractMessage(data) ?? 'Server error: $status',
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

  static String _extractMessage(dynamic data) {
    if (data == null) return 'Something went wrong';
    if (data is String) return data;
    if (data is Map) {
      // 1. Check for 'details' list (specific validation errors like password requirements)
      if (data['details'] != null &&
          data['details'] is List &&
          (data['details'] as List).isNotEmpty) {
        final firstDetail = (data['details'] as List).first;
        if (firstDetail is Map && firstDetail['msg'] != null) {
          return firstDetail['msg'].toString();
        }
      }

      // 2. Check for 'error' object (nested structure)
      if (data['error'] != null) {
        return _extractMessage(data['error']);
      }

      // 3. Check for 'message' key
      if (data['message'] != null) {
        return _extractMessage(data['message']);
      }

      // 4. Check for 'errors' key (common in some validation responses)
      if (data['errors'] != null && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          return firstError.toString();
        }
      }
    }
    return data.toString();
  }
}
