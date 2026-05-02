class FlightLocationModel {
  final String name;
  final String code;
  final String city;
  final String country;

  FlightLocationModel({
    required this.name,
    required this.code,
    required this.city,
    required this.country,
  });

  factory FlightLocationModel.fromJson(Map<String, dynamic> json) {
    return FlightLocationModel(
      name: json['name'] ?? '',
      code: json['code'] ?? json['iataCode'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'city': city,
      'country': country,
    };
  }

  @override
  String toString() => '$city ($code)';
}
