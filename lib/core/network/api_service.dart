import 'package:dio/dio.dart';
import 'package:egytravel_app/core/network/api_exceptions.dart';
import 'package:egytravel_app/core/network/dio_factory.dart';

class ApiService {
  final DioFactory _dioFactory = DioFactory();

  /// get
  Future<dynamic> get(String endPoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dioFactory.dio.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// post
  Future<dynamic> post(String endPoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dioFactory.dio.post(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// put
  Future<dynamic> put(String endPoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dioFactory.dio.put(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// delete
  Future<dynamic> delete(String endPoint) async {
    try {
      final response = await _dioFactory.dio.delete(endPoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}
