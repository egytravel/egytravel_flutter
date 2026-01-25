class RoomModel {
  final String id;
  final String roomType;
  final String imageUrl;
  final double pricePerNight;
  final List<String> features;
  final bool isAvailable;
  final int maxGuests;

  RoomModel({
    required this.id,
    required this.roomType,
    required this.imageUrl,
    required this.pricePerNight,
    required this.features,
    required this.isAvailable,
    required this.maxGuests,
  });

  static List<RoomModel> getMockRooms() {
    return [
      RoomModel(
        id: '1',
        roomType: 'Standard Room',
        imageUrl: '🛏️',
        pricePerNight: 120,
        features: ['Free WiFi', 'TV', 'Air Conditioning', 'Mini Bar'],
        isAvailable: true,
        maxGuests: 2,
      ),
      RoomModel(
        id: '2',
        roomType: 'Deluxe Room',
        imageUrl: '🛏️',
        pricePerNight: 180,
        features: [
          'Free WiFi',
          'TV',
          'Air Conditioning',
          'Mini Bar',
          'Sea View',
          'Balcony',
        ],
        isAvailable: true,
        maxGuests: 2,
      ),
      RoomModel(
        id: '3',
        roomType: 'Suite',
        imageUrl: '🛏️',
        pricePerNight: 300,
        features: [
          'Free WiFi',
          'TV',
          'Air Conditioning',
          'Mini Bar',
          'Sea View',
          'Balcony',
          'Living Room',
          'Jacuzzi',
        ],
        isAvailable: true,
        maxGuests: 4,
      ),
    ];
  }
}
