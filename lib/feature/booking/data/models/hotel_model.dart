import 'room_model.dart';

class HotelModel {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final double rating;
  final double pricePerNight;
  final List<String> amenities;
  final String description;
  final List<RoomModel> rooms;
  final int reviewCount;
  final String? bookingUrl;

  HotelModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.pricePerNight,
    required this.amenities,
    required this.description,
    required this.rooms,
    required this.reviewCount,
    this.bookingUrl,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is Map) {
      if (value.containsKey('amount')) return _parseDouble(value['amount']);
      if (value.containsKey('value')) return _parseDouble(value['value']);
      if (value.containsKey('price')) return _parseDouble(value['price']);
      if (value.containsKey('score')) return _parseDouble(value['score']);
      if (value.containsKey('rate')) return _parseDouble(value['rate']);
    }
    return 0.0;
  }

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    final String parsedName = json['name'] ?? json['hotelName'] ?? '';
    final String parsedCity = json['city'] ?? json['location'] ?? '';
    final String parsedAddress = json['address'] ?? '';
    
    final String finalLocation = parsedAddress.isNotEmpty && parsedCity.isNotEmpty 
        ? '$parsedAddress, $parsedCity'
        : (parsedAddress.isNotEmpty ? parsedAddress : parsedCity);

    return HotelModel(
      id: (json['id'] ?? json['_id'] ?? json['hotelId'] ?? '').toString(),
      name: parsedName,
      imageUrl: json['coverImage'] ?? json['thumbnail'] ?? json['imageUrl'] ?? json['image'] ?? '',
      location: finalLocation,
      rating: _parseDouble(json['rating']),
      pricePerNight: _parseDouble(json['pricePerNight'] ?? json['price']),
      amenities: (json['amenities'] as List?)?.cast<String>() ?? [
        'Free WiFi',
        'Air Conditioning',
        'Daily Housekeeping',
        '24-hour Front Desk',
      ],
      description: json['description'] ?? 'Enjoy a wonderful stay at $parsedName located in $finalLocation. This property offers excellent services and comfortable accommodations for a memorable experience.',
      rooms: (json['rooms'] as List? ?? [])
          .map((e) => RoomModel.fromJson(e))
          .toList(),
      reviewCount: json['reviewCount'] ?? 0,
      bookingUrl: json['bookingUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'location': location,
      'rating': rating,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'description': description,
      'rooms': rooms.map((e) => e.toJson()).toList(),
      'reviewCount': reviewCount,
      'bookingUrl': bookingUrl,
    };
  }

  // Mock data generator
  static List<HotelModel> getMockHotels({String? destination}) {
    return [
      HotelModel(
        id: '1',
        name: 'Grand Nile Hotel',
        imageUrl: '🏨',
        location: destination ?? 'Cairo, Egypt',
        rating: 4.8,
        pricePerNight: 120,
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Gym',
          'Spa',
          'Restaurant',
          'Room Service',
          'Parking',
        ],
        description:
            'Luxury hotel with stunning Nile views and world-class amenities. Perfect for both business and leisure travelers.',
        rooms: RoomModel.getMockRooms(),
        reviewCount: 2500,
      ),
      HotelModel(
        id: '2',
        name: 'Pyramids View Resort',
        imageUrl: '🏨',
        location: destination ?? 'Giza, Egypt',
        rating: 4.9,
        pricePerNight: 200,
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Gym',
          'Spa',
          'Restaurant',
          'Room Service',
          'Parking',
          'Pyramids View',
        ],
        description:
            'Experience the magic of ancient Egypt with breathtaking views of the pyramids from your room.',
        rooms: RoomModel.getMockRooms(),
        reviewCount: 3200,
      ),
      HotelModel(
        id: '3',
        name: 'Red Sea Paradise',
        imageUrl: '🏨',
        location: destination ?? 'Hurghada, Egypt',
        rating: 4.7,
        pricePerNight: 150,
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Gym',
          'Spa',
          'Restaurant',
          'Beach Access',
          'Water Sports',
        ],
        description:
            'Beachfront resort offering crystal-clear waters and endless entertainment options.',
        rooms: RoomModel.getMockRooms(),
        reviewCount: 1800,
      ),
      HotelModel(
        id: '4',
        name: 'Alexandria Marina Hotel',
        imageUrl: '🏨',
        location: destination ?? 'Alexandria, Egypt',
        rating: 4.6,
        pricePerNight: 100,
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Gym',
          'Restaurant',
          'Sea View',
          'Parking',
        ],
        description:
            'Modern hotel in the heart of Alexandria with Mediterranean charm and excellent service.',
        rooms: RoomModel.getMockRooms(),
        reviewCount: 1500,
      ),
      HotelModel(
        id: '5',
        name: 'Luxor Temple Suites',
        imageUrl: '🏨',
        location: destination ?? 'Luxor, Egypt',
        rating: 4.8,
        pricePerNight: 180,
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Gym',
          'Spa',
          'Restaurant',
          'Temple View',
          'Tour Desk',
        ],
        description:
            'Historic hotel near ancient temples offering an authentic Egyptian experience.',
        rooms: RoomModel.getMockRooms(),
        reviewCount: 2100,
      ),
      HotelModel(
        id: '6',
        name: 'Sharm El Sheikh Resort',
        imageUrl: '🏨',
        location: destination ?? 'Sharm El Sheikh, Egypt',
        rating: 4.9,
        pricePerNight: 220,
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Gym',
          'Spa',
          'Restaurant',
          'Beach Access',
          'Diving Center',
          'Kids Club',
        ],
        description:
            'Premium resort with world-class diving spots and family-friendly facilities.',
        rooms: RoomModel.getMockRooms(),
        reviewCount: 2800,
      ),
    ];
  }
}
