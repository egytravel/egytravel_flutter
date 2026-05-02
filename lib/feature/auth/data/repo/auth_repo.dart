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
      final response = await _apiService.post(EndPoint.login, data: {
        'email': email,
        'password': password,
      });

      final user = UserModel.fromJson(response['data']);
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

  ///Register
  Future<UserModel?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(EndPoint.register, data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': 'user',
      });

      final user = UserModel.fromJson(response['data']);
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

  ///Forgot Password
  Future<void> forgotPassword({required String email}) async {
    try {
      await _apiService.post(EndPoint.forgotPassword, data: {
        'email': email.trim(),
      });
    } on ApiError catch (_) {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  ///Reset Password (Items 7 in Postman)
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _apiService.post(EndPoint.resetPassword, data: {
        'email': email.trim(),
        'otp': otp,
        'newPassword': newPassword,
      });
    } on ApiError catch (_) {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
