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
    final data = json['data'] as Map<String, dynamic>;

    return ExploreResponseModel(
      categories: List<String>.from(data['categories'] ?? []),
      places: (data['places'] as List<dynamic>? ?? [])
          .map((e) => ExploreItemModel.fromPlaceJson(e))
          .toList(),
      recommended: (data['recommended'] as List<dynamic>? ?? [])
          .map((e) => ExploreItemModel.fromPlaceJson(e))
          .toList(),
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
