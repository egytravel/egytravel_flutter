import 'package:egytravel_app/core/utils/url_cleaner.dart';

class FlightModel {
  final String id;
  final String fromCity;
  final String toCity;
  final String airlineName;
  final String airlineLogo;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String duration;
  final double price;
  final double rating;
  final String flightClass; // Economy or Business
  final String flightNumber;
  final String baggage;

  FlightModel({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.airlineName,
    required this.airlineLogo,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.rating,
    required this.flightClass,
    required this.flightNumber,
    required this.baggage,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is Map) {
      if (value.containsKey('amount')) return _parseDouble(value['amount']);
      if (value.containsKey('value')) return _parseDouble(value['value']);
      if (value.containsKey('price')) return _parseDouble(value['price']);
      if (value.containsKey('totalPrice')) return _parseDouble(value['totalPrice']);
      if (value.containsKey('score')) return _parseDouble(value['score']);
      if (value.containsKey('rate')) return _parseDouble(value['rate']);
    }
    return 0.0;
  }

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    // Handle airline
    String name = '';
    String logo = '';
    if (json['airline'] is Map) {
      name = json['airline']['name'] ?? '';
      logo = json['airline']['logo'] ?? '';
    } else {
      name = (json['airline'] is String) ? json['airline'] : (json['airlineName'] ?? '');
      logo = json['airlineLogo'] ?? '';
    }

    // Handle departure
    String from = '';
    String depTime = DateTime.now().toIso8601String();
    if (json['departure'] is Map) {
      from = json['departure']['city'] ?? '';
      depTime = json['departure']['time'] ?? depTime;
    } else {
      from = json['departureCity'] ?? json['fromCity'] ?? '';
      depTime = json['departureDate'] ?? json['departureTime'] ?? depTime;
    }

    // Handle arrival
    String to = '';
    String arrTime = DateTime.now().toIso8601String();
    if (json['arrival'] is Map) {
      to = json['arrival']['city'] ?? '';
      arrTime = json['arrival']['time'] ?? arrTime;
    } else {
      to = json['arrivalCity'] ?? json['toCity'] ?? '';
      arrTime = json['arrivalDate'] ?? json['arrivalTime'] ?? arrTime;
    }

    return FlightModel(
      id: (json['id'] ?? json['_id'] ?? json['flightId'] ?? '').toString(),
      fromCity: from,
      toCity: to,
      airlineName: name,
      airlineLogo: UrlCleaner.clean(logo),
      departureTime: DateTime.parse(depTime),
      arrivalTime: DateTime.parse(arrTime),
      duration: json['duration'] ?? '',
      price: _parseDouble(json['price'] ?? json['totalPrice']),
      rating: _parseDouble(json['rating']),
      flightClass: json['cabinClass'] ?? json['travelClass'] ?? json['flightClass'] ?? 'Economy',
      flightNumber: json['flightNumber'] ?? '',
      baggage: json['baggage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureCity': fromCity,
      'arrivalCity': toCity,
      'airline': airlineName,
      'airlineLogo': airlineLogo,
      'departureDate': departureTime.toIso8601String(),
      'arrivalDate': arrivalTime.toIso8601String(),
      'duration': duration,
      'price': price,
      'rating': rating,
      'travelClass': flightClass,
      'flightNumber': flightNumber,
      'baggage': baggage,
    };
  }

  // Mock data generator
  static List<FlightModel> getMockFlights({
    String? from,
    String? to,
    String? flightClass,
  }) {
    return [
      FlightModel(
        id: '1',
        fromCity: from ?? 'Cairo',
        toCity: to ?? 'London',
        airlineName: 'EgyptAir',
        airlineLogo: '✈️',
        departureTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 15)),
        duration: '5h 00m',
        price: flightClass == 'Business' ? 1200 : 450,
        rating: 4.5,
        flightClass: flightClass ?? 'Economy',
        flightNumber: 'MS777',
        baggage: '30kg',
      ),
      FlightModel(
        id: '2',
        fromCity: from ?? 'Cairo',
        toCity: to ?? 'London',
        airlineName: 'British Airways',
        airlineLogo: '🛫',
        departureTime: DateTime.now().add(const Duration(days: 7, hours: 14)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 19)),
        duration: '5h 00m',
        price: flightClass == 'Business' ? 1500 : 520,
        rating: 4.8,
        flightClass: flightClass ?? 'Economy',
        flightNumber: 'BA156',
        baggage: '30kg',
      ),
      FlightModel(
        id: '3',
        fromCity: from ?? 'Cairo',
        toCity: to ?? 'London',
        airlineName: 'Lufthansa',
        airlineLogo: '🛩️',
        departureTime: DateTime.now().add(const Duration(days: 7, hours: 8)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 13)),
        duration: '5h 00m',
        price: flightClass == 'Business' ? 1350 : 480,
        rating: 4.7,
        flightClass: flightClass ?? 'Economy',
        flightNumber: 'LH582',
        baggage: '30kg',
      ),
      FlightModel(
        id: '4',
        fromCity: from ?? 'Cairo',
        toCity: to ?? 'London',
        airlineName: 'Emirates',
        airlineLogo: '🛫',
        departureTime: DateTime.now().add(const Duration(days: 7, hours: 16)),
        arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 21)),
        duration: '5h 00m',
        price: flightClass == 'Business' ? 1800 : 600,
        rating: 4.9,
        flightClass: flightClass ?? 'Economy',
        flightNumber: 'EK921',
        baggage: '40kg',
      ),
    ];
  }
}
