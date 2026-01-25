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
