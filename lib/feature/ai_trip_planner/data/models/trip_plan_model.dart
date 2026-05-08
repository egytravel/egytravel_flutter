class TripPlanModel {
  final String type;
  final String userId;
  final TripData data;

  TripPlanModel({required this.type, required this.userId, required this.data});

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    return TripPlanModel(
      type: json['type'] ?? '',
      userId: json['user_id'] ?? '',
      data: TripData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': userId,
      'data': data.toJson(),
    };
  }
}

class TripData {
  final AiHotelModel? hotel;
  final List<AiDayModel> days;

  TripData({this.hotel, required this.days});

  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      hotel: json['hotel'] != null ? AiHotelModel.fromJson(json['hotel']) : null,
      days: (json['days'] as List?)?.map((x) => AiDayModel.fromJson(x)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotel': hotel?.toJson(),
      'days': days.map((x) => x.toJson()).toList(),
    };
  }
}

class AiHotelModel {
  final String name;
  final double lat;
  final double lon;
  final double score;

  AiHotelModel({required this.name, required this.lat, required this.lon, required this.score});

  factory AiHotelModel.fromJson(Map<String, dynamic> json) {
    return AiHotelModel(
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      score: (json['score'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'score': score,
    };
  }
}

class AiDayModel {
  final int day;
  final List<AiActivityModel> activities;

  AiDayModel({required this.day, required this.activities});

  factory AiDayModel.fromJson(Map<String, dynamic> json) {
    return AiDayModel(
      day: json['day'] ?? 0,
      activities: (json['activities'] as List?)?.map((x) => AiActivityModel.fromJson(x)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'activities': activities.map((x) => x.toJson()).toList(),
    };
  }
}

class AiActivityModel {
  final String time;
  final String title;
  final String description;

  AiActivityModel({required this.time, required this.title, required this.description});

  factory AiActivityModel.fromJson(Map<String, dynamic> json) {
    return AiActivityModel(
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'title': title,
      'description': description,
    };
  }
}
