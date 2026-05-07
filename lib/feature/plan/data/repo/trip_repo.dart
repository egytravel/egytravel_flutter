import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import '../model/trip_model.dart';

class TripRepo {
  final ApiService _apiService;

  TripRepo({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  // ── TRIPS ─────────────────────────────────────────────────────────────────

  /// GET /trips or GET /trips?status=planning
  Future<List<TripModel>> getAllTrips({String? status}) async {
    String url = EndPoint.trips;
    if (status != null && status.isNotEmpty) {
      url = '${EndPoint.trips}?status=$status';
    }
    final response = await _apiService.get(url);
    final data = _extractList(response);
    return data.map((e) => TripModel.fromJson(e)).toList();
  }

  /// POST /trips
  Future<TripModel> createTrip(TripModel trip) async {
    final response = await _apiService.post(
      EndPoint.trips,
      data: trip.toJson(),
    );
    final data = _extractData(response);
    if (data['tripId'] != null &&
        data['title'] == null &&
        data['destination'] == null) {
      return TripModel.fromJson({
        ...trip.toJson(),
        'status': trip.status,
        'id': data['tripId'],
        ...data,
      });
    }
    return TripModel.fromJson(data);
  }

  /// GET /trips/{id}
  Future<TripModel> getTripDetails(String id) async {
    final response = await _apiService.get(EndPoint.tripById(id));
    final data = _extractData(response);
    return TripModel.fromJson(data);
  }

  /// PUT /trips/{id}
  Future<TripModel> updateTrip(String id, Map<String, dynamic> updates) async {
    final response = await _apiService.put(
      EndPoint.tripById(id),
      data: updates,
    );
    final data = _extractData(response);
    return TripModel.fromJson(data);
  }

  /// DELETE /trips/{id}
  Future<void> deleteTrip(String id) async {
    await _apiService.delete(EndPoint.tripById(id));
  }

  // ── DAYS ───────────────────────────────────────────────────────────────────

  /// POST /trips/{tripId}/days
  Future<TripDayModel> addDayToTrip(
    String tripId,
    Map<String, dynamic> dayData,
  ) async {
    final response = await _apiService.post(
      EndPoint.tripDays(tripId),
      data: dayData,
    );
    final data = _extractData(response);
    return TripDayModel.fromJson(data);
  }

  /// GET /trips/{tripId}/days
  Future<List<TripDayModel>> getTripDays(String tripId) async {
    final response = await _apiService.get(EndPoint.tripDays(tripId));
    final data = _extractList(response);
    return data.map((e) => TripDayModel.fromJson(e)).toList();
  }

  /// GET /trips/{tripId}/days/{dayId}
  Future<TripDayModel> getSingleDay(String tripId, String dayId) async {
    final response = await _apiService.get(EndPoint.tripDayById(tripId, dayId));
    final data = _extractData(response);
    return TripDayModel.fromJson(data);
  }

  /// PUT /trips/{tripId}/days/{dayId}
  Future<TripDayModel> updateDay(
    String tripId,
    String dayId,
    Map<String, dynamic> dayData,
  ) async {
    final response = await _apiService.put(
      EndPoint.tripDayById(tripId, dayId),
      data: dayData,
    );
    final data = _extractData(response);
    return TripDayModel.fromJson(data);
  }

  /// DELETE /trips/{tripId}/days/{dayId}
  Future<void> deleteDay(String tripId, String dayId) async {
    await _apiService.delete(EndPoint.tripDayById(tripId, dayId));
  }

  // ── HOTEL BOOKING ──────────────────────────────────────────────────────────

  /// POST /api/bookings/hotel  (#11)
  Future<Map<String, dynamic>> attachHotel(
    Map<String, dynamic> hotelData,
  ) async {
    final response = await _apiService.post(
      EndPoint.tripAttachHotel,
      data: hotelData,
    );
    return response is Map<String, dynamic> ? response : {};
  }

  // ── MAP ────────────────────────────────────────────────────────────────────

  /// GET /api/trips/{tripId}/map  (#13)
  Future<List<TripMapMarker>> getTripMapMarkers(String tripId) async {
    final response = await _apiService.get(EndPoint.tripMapMarkers(tripId));
    final data = _extractList(response);
    return data.map((e) => TripMapMarker.fromJson(e)).toList();
  }

  // ── SEARCH ─────────────────────────────────────────────────────────────────

  /// GET /api/home/search?q=<query>  (#5)
  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];
    final response = await _apiService.get(EndPoint.searchPlaces(query));
    return _extractList(response);
  }

  // ── PLACES ─────────────────────────────────────────────────────────────────

  /// POST /api/trips/{tripId}/days/{dayId}/places  (#14)
  Future<Map<String, dynamic>> addPlaceToDay(
    String tripId,
    String dayId,
    Map<String, dynamic> placeData,
  ) async {
    final response = await _apiService.post(
      EndPoint.tripDayPlaces(tripId, dayId),
      data: placeData,
    );
    return response is Map<String, dynamic> ? response : {};
  }

  /// DELETE /api/trips/{tripId}/days/{dayId}/places/{index}  (#15)
  Future<void> removePlaceFromDay(
    String tripId,
    String dayId,
    int placeIndex,
  ) async {
    await _apiService.delete(
      EndPoint.tripDayPlaceByIndex(tripId, dayId, placeIndex),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Safely extracts a list from the API response (handles both raw List
  /// and { "data": [...] } wrapper).
  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is List) return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Safely extracts a single object from the API response.
  Map<String, dynamic> _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        return response['data'];
      }
      return response;
    }
    return {};
  }
}
