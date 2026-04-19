import 'package:egytravel_app/feature/home/data/model/destination_model.dart';
import 'package:egytravel_app/feature/home/data/model/place_model.dart';

class HomeResponse {
  final List<Place> featured;
  final List<Place> popular;
  final List<Destination> destinations;

  HomeResponse({
    required this.featured,
    required this.popular,
    required this.destinations,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      featured: (json['featured'] as List? ?? [])
          .map((e) => Place.fromJson(e))
          .toList(),
      popular: (json['popular'] as List? ?? [])
          .map((e) => Place.fromJson(e))
          .toList(),
      destinations: (json['destinations'] as List? ?? [])
          .map((e) => Destination.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featured': featured.map((e) => e.toJson()).toList(),
      'popular': popular.map((e) => e.toJson()).toList(),
      'destinations': destinations.map((e) => e.toJson()).toList(),
    };
  }
}
