import 'package:dio/dio.dart';
import 'package:egytravel_app/core/network/api_exceptions.dart';
import 'package:egytravel_app/core/network/dio_factory.dart';

class ApiService {
  final DioFactory _dioFactory = DioFactory();

  /// get
  Future<dynamic> get(String endPoint) async {
    try {
      final response = await _dioFactory.dio.get(endPoint);
      return response;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// post
  Future<dynamic> post(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioFactory.dio.post(endPoint, data: body);
      return response;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// put
  Future<dynamic> put(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioFactory.dio.post(endPoint, data: body);
      return response;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// delete
  Future<dynamic> delete(String endPoint) async {
    try {
      final response = await _dioFactory.dio.delete(endPoint);
      return response;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}
