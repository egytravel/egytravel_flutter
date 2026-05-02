import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/profile/data/model/profile_model.dart';

class ProfileRepo {
  final ApiService _api = ApiService();

  // ── GET /api/users/profile ─────────────────────────────────────────────
  Future<ProfileModel> getProfile() async {
    final response = await _api.get(EndPoint.profile);
    final userMap = _extractUser(response);
    return ProfileModel.fromJson(userMap);
  }

  // ── PUT /api/users/profile ─────────────────────────────────────────────
  Future<ProfileModel> updateProfile({
    String? name,
    String? phone,
    String? nationality,
    String? dateOfBirth,
    String? profilePhotoUrl,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (nationality != null) 'nationality': nationality,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
    };
    final response = await _api.put(EndPoint.profile, data: body);
    final userMap = _extractUser(response);
    return ProfileModel.fromJson(userMap);
  }

  // ── POST /api/users/change-password ────────────────────────────────────
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _api.post(EndPoint.changePassword, data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // ── GET /api/users/notifications ──────────────────────────────────────
  Future<Map<String, bool>> getNotifications() async {
    final response = await _api.get(EndPoint.notifications);
    final data = _extractData(response);
    return {
      'push_enabled': (data['push_enabled'] as bool?) ?? true,
      'email_enabled': (data['email_enabled'] as bool?) ?? true,
    };
  }

  // ── PUT /api/users/notifications ──────────────────────────────────────
  Future<void> updateNotifications({
    required bool pushEnabled,
    required bool emailEnabled,
  }) async {
    await _api.put(EndPoint.notifications, data: {
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
    });
  }

  // ── GET /api/users/travel-history ─────────────────────────────────────
  Future<List<Map<String, dynamic>>> getTravelHistory() async {
    final response = await _api.get(EndPoint.travelHistory);
    final data = _extractData(response);
    if (data['history'] is List) {
      return (data['history'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ── POST /api/users/delete-account ────────────────────────────────────
  Future<void> deleteAccount({required String password}) async {
    await _api.post(EndPoint.deleteAccount, data: {'password': password});
  }

  // ── GET /api/trips ────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMyTrips() async {
    final response = await _api.get(EndPoint.trips);
    final data = _extractData(response);
    if (data['trips'] is List) {
      return (data['trips'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ── PUT /api/trips/:id ────────────────────────────────────────────────
  Future<void> updateTrip(String tripId, Map<String, dynamic> body) async {
    await _api.put(EndPoint.tripById(tripId), data: body);
  }

  // ── DELETE /api/trips/:id ─────────────────────────────────────────────
  Future<void> deleteTrip(String tripId) async {
    await _api.delete(EndPoint.tripById(tripId));
  }

  // ── GET /api/bookings ─────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMyBookings({String? status}) async {
    final endpoint = status != null
        ? '${EndPoint.bookings}?status=$status'
        : EndPoint.bookings;
    final response = await _api.get(endpoint);
    final data = _extractData(response);
    if (data['bookings'] is List) {
      return (data['bookings'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ── GET /api/favorites ────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMyFavorites({String? type}) async {
    final endpoint = type != null
        ? '${EndPoint.favorites}?type=$type'
        : EndPoint.favorites;
    final response = await _api.get(endpoint);
    final data = _extractData(response);
    if (data['favorites'] is List) {
      return (data['favorites'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ── POST /api/favorites ───────────────────────────────────────────────
  Future<void> addToFavorites({
    required String itemId,
    required String itemType,
    Map<String, dynamic>? details,
  }) async {
    await _api.post(EndPoint.favorites, data: {
      'itemId': itemId,
      'itemType': itemType,
      if (details != null) 'details': details,
    });
  }

  // ── DELETE /api/favorites/:id ─────────────────────────────────────────
  Future<void> removeFromFavorites(String favoriteId) async {
    await _api.delete(EndPoint.favoriteById(favoriteId));
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  Map<String, dynamic> _extractUser(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        final data = response['data'] as Map<String, dynamic>;
        if (data.containsKey('user')) return data['user'] as Map<String, dynamic>;
        return data;
      }
      return response;
    }
    throw Exception('Unexpected response format');
  }

  Map<String, dynamic> _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response.containsKey('data')
          ? response['data'] as Map<String, dynamic>
          : response;
    }
    return {};
  }
}
