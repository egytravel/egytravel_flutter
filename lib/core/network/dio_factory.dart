import 'package:dio/dio.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: EndPoint.baseUrl,
            receiveDataWhenStatusError: true,
            connectTimeout: const Duration(seconds: 8),
            headers: {
              'Cache-Control': 'no-cache',
              'Content-Type': 'application/json',
              'Accept': '*/*', // 🔥 صح
              'User-Agent': 'PostmanRuntime/7.50.0',
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            maxWidth: 100,
          ),
        );

  Dio get dio => _dio;
}
