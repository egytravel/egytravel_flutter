import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/booking/data/models/flight_model.dart';
import 'package:egytravel_app/feature/booking/data/models/hotel_model.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_response_model.dart';
import 'package:egytravel_app/feature/home/data/model/event_model.dart';

class ExploreRepo {
  final ApiService _apiService;

  ExploreRepo({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<ExploreResponseModel> getExploreData() async {
    final response = await _apiService.get(EndPoint.explore);
    
    // Safely extract the 'data' map if the response is wrapped
    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;
        
    return ExploreResponseModel.fromJson(data);
  }

  Future<List<ExploreItemModel>> getEvents() async {
    final response = await _apiService.get(EndPoint.events);
    
    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as List
        : response as List;
        
    return data.map((e) => ExploreItemModel.fromEventModel(EventModel.fromJson(e))).toList();
  }

  Future<List<HotelModel>> exploreHotels({
    required String city,
    required String checkin,
    required String checkout,
    required int guests,
  }) async {
    final response = await _apiService.get(
      EndPoint.exploreHotels,
      queryParameters: {
        'city': city,
        'checkin': checkin,
        'checkout': checkout,
        'guests': guests,
      },
    );

    final List data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as List
        : (response is List ? response : []);

    return data.map((e) => HotelModel.fromJson(e)).toList();
  }

  Future<List<FlightModel>> exploreFlights({
    required String from,
    required String to,
    required String date,
    String flightClass = 'ECONOMY',
  }) async {
    final response = await _apiService.get(
      EndPoint.exploreFlightsApi,
      queryParameters: {
        'origin': from,
        'destination': to,
        'departureDate': date,
        'adults': 1,
        'travelClass': flightClass.toUpperCase(),
      },
    );

    final List data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as List
        : (response is List ? response : []);

    return data.map((e) => FlightModel.fromJson(e)).toList();
  }
}
