import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import '../model/trip_model.dart';

class TripRepo {
  final ApiService _apiService;

  TripRepo({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<TripModel>> getAllTrips() async {
    final response = await _apiService.get('${EndPoint.trips}?status=planning');
    final data = (response as Map<String, dynamic>)['data'] as List;
    return data.map((e) => TripModel.fromJson(e)).toList();
  }

  Future<TripModel> createTrip(TripModel trip) async {
    final response = await _apiService.post(EndPoint.trips, data: trip.toJson());
    final data = (response as Map<String, dynamic>)['data'];
    return TripModel.fromJson(data);
  }

  Future<TripModel> getTripDetails(String id) async {
    final response = await _apiService.get(EndPoint.tripById(id));
    final data = (response as Map<String, dynamic>)['data'];
    return TripModel.fromJson(data);
  }

  Future<void> updateTrip(String id, TripModel trip) async {
    await _apiService.put(EndPoint.tripById(id), data: trip.toJson());
  }

  Future<void> deleteTrip(String id) async {
    await _apiService.delete(EndPoint.tripById(id));
  }

  Future<void> addDayToTrip(String tripId, Map<String, dynamic> dayData) async {
    await _apiService.post(EndPoint.tripDays(tripId), data: dayData);
  }

  Future<List<TripDayModel>> getTripDays(String tripId) async {
    final response = await _apiService.get(EndPoint.tripDays(tripId));
    final data = (response as Map<String, dynamic>)['data'] as List;
    return data.map((e) => TripDayModel.fromJson(e)).toList();
  }

  Future<void> updateDay(String tripId, String dayId, Map<String, dynamic> dayData) async {
    await _apiService.put(EndPoint.tripDayById(tripId, dayId), data: dayData);
  }

  Future<void> deleteDay(String tripId, String dayId) async {
    await _apiService.delete(EndPoint.tripDayById(tripId, dayId));
  }

  Future<void> attachHotel(String tripId, Map<String, dynamic> hotelData) async {
    await _apiService.post(EndPoint.tripAttachHotel(tripId), data: hotelData);
  }

  Future<List<Map<String, dynamic>>> getTripMapMarkers(String tripId) async {
    final response = await _apiService.get(EndPoint.tripMapMarkers(tripId));
    final data = (response as Map<String, dynamic>)['data'] as List;
    return data.cast<Map<String, dynamic>>();
  }
}
