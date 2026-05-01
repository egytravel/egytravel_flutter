import 'package:dio/dio.dart';
import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoint.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )
    ..interceptors.add(
      // ── Auth Interceptor: injects Bearer token into every request ────────
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPreferencesHelper.getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    )
    ..interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ),
    );

  Dio get dio => _dio;
}