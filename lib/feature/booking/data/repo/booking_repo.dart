import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/booking/data/models/flight_model.dart';
import 'package:egytravel_app/feature/booking/data/models/hotel_model.dart';

class BookingRepo {
  final ApiService _apiService = ApiService();

  Future<List<FlightModel>> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    String? returnDate,
    int adults = 1,
    String travelClass = 'ECONOMY',
  }) async {
    final queryParameters = {
      'origin': origin,
      'destination': destination,
      'departureDate': departureDate,
      if (returnDate != null) 'returnDate': returnDate,
      'adults': adults,
      'travelClass': travelClass,
    };

    final response = await _apiService.get(
      EndPoint.flightSearch,
      queryParameters: queryParameters,
    );

    List data = [];
    if (response is List) {
      data = response;
    } else if (response is Map<String, dynamic> && response['data'] is List) {
      data = response['data'];
    }

    return data.map((e) => FlightModel.fromJson(e)).toList();
  }

  Future<List<HotelModel>> searchHotels({
    required String location,
    required String checkin,
    required String checkout,
    int guests = 1,
    int rooms = 1,
  }) async {
    final queryParameters = {
      'location': location,
      'checkin': checkin,
      'checkout': checkout,
      'guests': guests,
      'rooms': rooms,
    };

    final response = await _apiService.get(
      EndPoint.hotelSearch,
      queryParameters: queryParameters,
    );

    List data = [];
    if (response is List) {
      data = response;
    } else if (response is Map<String, dynamic> && response['data'] is List) {
      data = response['data'];
    }

    return data.map((e) => HotelModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> createFlightBooking(Map<String, dynamic> bookingData) async {
    final response = await _apiService.post(
      EndPoint.bookingFlight,
      data: bookingData,
    );
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createHotelBooking(Map<String, dynamic> bookingData) async {
    final response = await _apiService.post(
      EndPoint.bookingHotel,
      data: bookingData,
    );
    return response as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getUserBookings({String? type}) async {
    final response = await _apiService.get(
      EndPoint.bookings,
      queryParameters: type != null ? {'type': type} : null,
    );

    List data = [];
    if (response is List) {
      data = response;
    } else if (response is Map<String, dynamic> && response['data'] is List) {
      data = response['data'];
    }

    return data.cast<Map<String, dynamic>>();
  }
}
