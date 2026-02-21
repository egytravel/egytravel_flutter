import 'package:get/get.dart';

enum ExploreItemType { place, restaurant, hotel, flight }

class ExploreItemModel {
  final String title;
  final String location;
  final String image;
  final double rating;
  final String price;
  final String category;
  final ExploreItemType type;

  // Specific fields
  final String? date;
  final String? cuisine;
  final String? features;

  // Favorite state (reactive)
  final RxBool isFavorite;

  ExploreItemModel({
    required this.title,
    required this.location,
    required this.image,
    required this.rating,
    required this.price,
    required this.category,
    required this.type,
    this.date,
    this.cuisine,
    this.features,
    bool isFavorite = false,
  }) : isFavorite = isFavorite.obs;
}
