import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';

class ExploreResponseModel {
  final List<String> categories;
  final List<ExploreItemModel> places;
  final List<ExploreItemModel> recommended;
  final List<ExploreItemModel> restaurants;
  final List<ExploreItemModel> hotels;
  final List<ExploreItemModel> flights;

  ExploreResponseModel({
    required this.categories,
    required this.places,
    required this.recommended,
    required this.restaurants,
    required this.hotels,
    required this.flights,
  });

  factory ExploreResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if data is wrapped in a 'data' key or returned directly
    final data = (json['data'] != null && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final placesList = (data['popularPlaces'] as List<dynamic>? ?? data['places'] as List<dynamic>? ?? [])
        .map((e) => ExploreItemModel.fromPlaceJson(e))
        .toList();

    return ExploreResponseModel(
      categories: (data['categories'] as List? ?? [])
          .map((e) => e is Map ? (e['name'] ?? e['title'] ?? e.toString()).toString() : e.toString())
          .toList(),
      places: placesList,
      recommended: placesList.where((p) => p.isRecommended).toList(),
      restaurants: (data['restaurants'] as List<dynamic>? ?? [])
          .map((e) => ExploreItemModel.fromRestaurantJson(e))
          .toList(),
      hotels: (data['hotels'] as List<dynamic>? ?? [])
          .map((e) => ExploreItemModel.fromHotelJson(e))
          .toList(),
      flights: (data['flights'] as List<dynamic>? ?? [])
          .map((e) => ExploreItemModel.fromFlightJson(e))
          .toList(),
    );
  }
}
