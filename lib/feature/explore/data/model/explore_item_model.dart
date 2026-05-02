import 'package:egytravel_app/core/utils/url_cleaner.dart';
import 'package:get/get.dart';

enum ExploreItemType { place, restaurant, hotel, flight, event }

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
  final String? bookingUrl;

  // Flight-specific fields
  final String? date;
  final String? route;
  final String? origin;
  final String? destination;
  final String? duration;
  final String? airline;

  // Event-specific fields
  final String? startDate;
  final String? ticketUrl;

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
    this.bookingUrl,
    this.date,
    this.route,
    this.origin,
    this.destination,
    this.duration,
    this.airline,
    this.startDate,
    this.ticketUrl,
    bool isFavorite = false,
  }) : isFavorite = isFavorite.obs;

  /// Parse an event item from EventModel (conversion)
  factory ExploreItemModel.fromEventModel(dynamic event) {
    // We use dynamic to avoid direct import circular dependency if needed
    // But since they are in same package it's fine
    return ExploreItemModel(
      id: event.id,
      title: event.title,
      location: '${event.city}, ${event.location}',
      image: event.coverImage,
      rating: 0,
      price: event.price ?? (event.isFree ? 'Free' : 'N/A'),
      category: event.category,
      type: ExploreItemType.event,
      description: event.description,
      startDate: event.startDate,
      ticketUrl: event.ticketUrl,
    );
  }

  /// Parse a place item from API JSON
  factory ExploreItemModel.fromPlaceJson(Map<String, dynamic> json) {
    return ExploreItemModel(
      id: _s(json['id']),
      title: _s(json['title']),
      location: _s(json['location']),
      image: UrlCleaner.clean(_s(json['coverImage'] ??
          json['image'] ??
          json['imageUrl'] ??
          json['thumbnail'])),
      rating: _toDouble(json['rating']),
      price: _s(json['priceDisplay'],
          '${json['price'] ?? 0} ${json['currency'] ?? ''}'),
      category: _s(json['category']),
      type: ExploreItemType.place,
      description: _sn(json['description']),
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
      isFeatured: json['isFeatured'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
    );
  }

  /// Parse a restaurant item from API JSON
  factory ExploreItemModel.fromRestaurantJson(Map<String, dynamic> json) {
    return ExploreItemModel(
      id: _s(json['id']),
      title: _s(json['title']),
      location: _s(json['location']),
      image: UrlCleaner.clean(_s(json['coverImage'] ?? json['image'])),
      rating: _toDouble(json['rating']),
      price: _s(json['priceDisplay'] ?? json['priceRange'], '\$\$'),
      category: _s(json['category']),
      type: ExploreItemType.restaurant,
      description: _sn(json['description']),
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
      cuisine: _sn(json['cuisine']),
      openingHours: _sn(json['openingHours']),
      phone: _sn(json['phone']),
    );
  }

  /// Parse a hotel item from API JSON
  factory ExploreItemModel.fromHotelJson(Map<String, dynamic> json) {
    final priceData = json['price'];
    String priceStr = 'N/A';
    if (priceData is Map) {
      priceStr = '${priceData['amount'] ?? 0} ${priceData['currency'] ?? ''}';
    }

    return ExploreItemModel(
      id: _s(json['hotelId'] ?? json['id']),
      title: _s(json['name'] ?? json['title']),
      location: _s(json['address'] ?? json['city']),
      image: UrlCleaner.clean(_s(json['coverImage'] ?? json['image'])),
      rating: _toDouble(json['rating']),
      price: priceStr,
      category: _s(json['category'], 'Hotel'),
      type: ExploreItemType.hotel,
      description: _sn(json['reviewWord'] ?? json['description']),
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
      features: _sn(json['reviewWord']),
      amenities: json['amenities'] != null ? List<String>.from(json['amenities']) : null,
      bookingUrl: _sn(json['bookingUrl']),
    );
  }

  /// Parse a flight item from API JSON
  factory ExploreItemModel.fromFlightJson(Map<String, dynamic> json) {
    final airlineData = json['airline'];
    final departure = json['departure'];
    final arrival = json['arrival'];
    final priceData = json['price'];

    String title = 'Flight';
    String location = 'Unknown Route';
    if (departure is Map && arrival is Map) {
      title = '${departure['city']} to ${arrival['city']}';
      location = '${departure['airport']} ➔ ${arrival['airport']}';
    }

    String priceStr = 'N/A';
    if (priceData is Map) {
      priceStr = '${priceData['amount'] ?? 0} ${priceData['currency'] ?? ''}';
    }

    return ExploreItemModel(
      id: _s(json['flightId'] ?? json['id']),
      title: title,
      location: location,
      image: airlineData is Map ? UrlCleaner.clean(_s(airlineData['logo'])) : '',
      rating: 0,
      price: priceStr,
      category: _s(json['category'], 'Flight'),
      type: ExploreItemType.flight,
      airline: airlineData is Map ? _s(airlineData['name']) : null,
      duration: _sn(json['duration']),
      date: departure is Map ? _sn(departure['time']) : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static String _s(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    if (value is Map) {
      return (value['name'] ?? value['title'] ?? value['text'] ?? value.toString()).toString();
    }
    return value.toString();
  }

  static String? _sn(dynamic value) {
    if (value == null) return null;
    return _s(value);
  }
}
