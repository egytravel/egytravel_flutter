class EventModel {
  final String id;
  final String title;
  final String description;
  final String? shortDescription;
  final String category;
  final String location;
  final String city;
  final String startDate;
  final String? endDate;
  final String coverImage;
  final List<String> images;
  final String? price;
  final bool isFree;
  final bool isFeatured;
  final String? ticketUrl;
  final List<String> tags;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.shortDescription,
    required this.category,
    required this.location,
    required this.city,
    required this.startDate,
    this.endDate,
    required this.coverImage,
    required this.images,
    this.price,
    this.isFree = false,
    this.isFeatured = false,
    this.ticketUrl,
    required this.tags,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'],
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      startDate: json['startDate'] ?? json['date'] ?? '',
      endDate: json['endDate'],
      coverImage: json['coverImage'] ?? json['image'] ?? '',
      images: (json['images'] as List? ?? []).cast<String>(),
      price: json['price']?.toString(),
      isFree: json['isFree'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      ticketUrl: json['ticketUrl'],
      tags: json['tags'] is String
          ? (json['tags'] as String).split(',').map((e) => e.trim()).toList()
          : (json['tags'] as List? ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'shortDescription': shortDescription,
      'category': category,
      'location': location,
      'city': city,
      'startDate': startDate,
      'endDate': endDate,
      'coverImage': coverImage,
      'images': images,
      'price': price,
      'isFree': isFree,
      'isFeatured': isFeatured,
      'ticketUrl': ticketUrl,
      'tags': tags,
    };
  }
}
