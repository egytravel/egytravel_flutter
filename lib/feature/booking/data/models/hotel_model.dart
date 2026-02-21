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
  });

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
