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

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is Map) {
      if (value.containsKey('amount')) return _parseDouble(value['amount']);
      if (value.containsKey('value')) return _parseDouble(value['value']);
      if (value.containsKey('price')) return _parseDouble(value['price']);
    }
    return 0.0;
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      roomType: json['type'] ?? json['roomType'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      pricePerNight: _parseDouble(json['price'] ?? json['pricePerNight']),
      features: (json['features'] as List? ?? []).cast<String>(),
      isAvailable: json['isAvailable'] ?? true,
      maxGuests: json['maxGuests'] ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': roomType,
      'imageUrl': imageUrl,
      'price': pricePerNight,
      'features': features,
      'isAvailable': isAvailable,
      'maxGuests': maxGuests,
    };
  }

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
