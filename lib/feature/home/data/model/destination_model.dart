class Destination {
  final String id;
  final String name;
  final String? cityCode;
  final String? country;
  final String image;
  final String? description;
  final int? attractionsCount;
  final double? rating;

  Destination({
    required this.id,
    required this.name,
    this.cityCode,
    this.country,
    required this.image,
    this.description,
    this.attractionsCount,
    this.rating,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cityCode: json['cityCode'],
      country: json['country'],
      image: json['coverImage'] ?? '',
      description: json['description'],
      attractionsCount: json['attractionsCount'],
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cityCode': cityCode,
      'country': country,
      'coverImage': image,
      'description': description,
      'attractionsCount': attractionsCount,
      'rating': rating,
    };
  }
}

