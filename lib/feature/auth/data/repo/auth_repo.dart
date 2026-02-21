import 'package:dio/dio.dart';
import 'package:egytravel_app/core/error/api_error.dart';
import 'package:egytravel_app/core/locale_storage/shared_preferences_helper.dart';
import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/auth/data/model/user_model.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  ///Login
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(EndPoint.login, {
        'email': email,
        'password': password,
      });

      final user = UserModel.fromJson(response.data['data']);
      if (user.token != null && user.token!.isNotEmpty) {
        SharedPreferencesHelper.saveToken(user.token!);
      }
      return user;
    } on ApiError catch (_) {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
