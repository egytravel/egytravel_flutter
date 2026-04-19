import 'package:get/get.dart';

enum ExploreItemType { place, restaurant, hotel, flight }

class ExploreItemModel {
  final String id;
  final String title;
  final String location;
  final String image;
  final double rating;
  final String price;
  final String category;
  final ExploreItemType type;
  final String? description;
  final double? lat;
  final double? lng;

  // Place-specific fields
  final bool isFeatured;
  final bool isRecommended;

  // Restaurant-specific fields
  final String? cuisine;
  final String? openingHours;
  final String? phone;

  // Hotel-specific fields
  final String? features;
  final List<String>? amenities;

  // Flight-specific fields
  final String? date;
  final String? route;
  final String? origin;
  final String? destination;
  final String? duration;
  final String? airline;

  // Favorite state (reactive)
  final RxBool isFavorite;

  ExploreItemModel({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    required this.rating,
    required this.price,
    required this.category,
    required this.type,
    this.description,
    this.lat,
    this.lng,
    this.isFeatured = false,
    this.isRecommended = false,
    this.cuisine,
    this.openingHours,
    this.phone,
    this.features,
    this.amenities,
    this.date,
    this.route,
    this.origin,
    this.destination,
    this.duration,
    this.airline,
    bool isFavorite = false,
  }) : isFavorite = isFavorite.obs;

  /// Parse a place item from API JSON
  factory ExploreItemModel.fromPlaceJson(Map<String, dynamic> json) {
    return ExploreItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['priceDisplay'] ?? '\$${json['price'] ?? 0}',
      category: json['category'] ?? '',
      type: ExploreItemType.place,
      description: json['description'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      isFeatured: json['isFeatured'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
    );
  }

  /// Parse a restaurant item from API JSON
  factory ExploreItemModel.fromRestaurantJson(Map<String, dynamic> json) {
    return ExploreItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['priceDisplay'] ?? json['priceRange'] ?? '',
      category: json['category'] ?? '',
      type: ExploreItemType.restaurant,
      description: json['description'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      cuisine: json['cuisine'],
      openingHours: json['openingHours'],
      phone: json['phone'],
    );
  }

  /// Parse a hotel item from API JSON
  factory ExploreItemModel.fromHotelJson(Map<String, dynamic> json) {
    return ExploreItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['priceDisplay'] ?? '\$${json['pricePerNight'] ?? 0}/night',
      category: json['category'] ?? '',
      type: ExploreItemType.hotel,
      description: json['description'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      features: json['features'],
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : null,
    );
  }

  /// Parse a flight item from API JSON
  factory ExploreItemModel.fromFlightJson(Map<String, dynamic> json) {
    return ExploreItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['route'] ?? '',
      image: '',
      rating: 0,
      price: json['priceDisplay'] ?? '\$${json['price'] ?? 0}',
      category: json['category'] ?? '',
      type: ExploreItemType.flight,
      route: json['route'],
      origin: json['origin'],
      destination: json['destination'],
      duration: json['duration'],
      airline: json['airline'],
      date: json['frequency'],
    );
  }
}
