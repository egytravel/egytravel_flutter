import 'package:egytravel_app/core/utils/url_cleaner.dart';

class Place {
  final String? id;
  final String name;
  final String location;
  final String? city;
  final String? description;
  final String image;
  final double rating;
  final int? reviewCount;
  final int price;
  final String? currency;
  final String? category;
  final List<String>? images;
  final List<String>? tags;
  final List<String>? facilities;
  final bool? featured;
  final bool? popular;

  Place({
    this.id,
    required this.name,
    required this.location,
    this.city,
    this.description,
    required this.image,
    required this.rating,
    this.reviewCount,
    required this.price,
    this.currency,
    this.category,
    this.images,
    this.tags,
    this.facilities,
    this.featured,
    this.popular,
  });
  factory Place.fromJson(Map<String, dynamic> json) {
    final String mainImage = json['coverImage'] ?? 
                             json['image'] ?? 
                             json['imageUrl'] ?? 
                             json['thumbnail'] ?? 
                             (json['images'] != null && (json['images'] as List).isNotEmpty ? json['images'][0] : '');

    return Place(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      city: json['city'],
      description: json['description'],
      image: UrlCleaner.clean(mainImage),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'],
      price: json['pricePerPerson'] ?? 0,
      currency: json['currency'],
      category: json['category'],
      images: json['images'] != null
          ? UrlCleaner.cleanList(List<String>.from(json['images']))
          : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      facilities: json['facilities'] != null
          ? List<String>.from(json['facilities'])
          : null,
      featured: json['featured'],
      popular: json['popular'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'city': city,
      'description': description,
      'coverImage': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerPerson': price,
      'currency': currency,
      'category': category,
      'images': images,
      'tags': tags,
      'facilities': facilities,
      'featured': featured,
      'popular': popular,
    };
  }
}

