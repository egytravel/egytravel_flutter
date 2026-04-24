import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _onboardingKey = 'onboarding_completed';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }

  static Future<String> getToken() async {
    return _prefs?.getString(_tokenKey) ?? '';
  }

  static Future<void> clearToken() async {
    await _prefs?.remove(_tokenKey);
  }

  static Future<void> setOnboardingCompleted() async {
    await _prefs?.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    return _prefs?.getBool(_onboardingKey) ?? false;
  }
}
