import 'package:egytravel_app/core/utils/url_cleaner.dart';

class TripModel {
  final String id;
  final String title;
  final String? description;
  final String? destination;
  final String? startDate;
  final String? endDate;
  final double? budget;
  final String status;
  final List<TripDayModel>? days;

  TripModel({
    required this.id,
    required this.title,
    this.description,
    this.destination,
    this.startDate,
    this.endDate,
    this.budget,
    required this.status,
    this.days,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      destination: json['destination'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      budget: (json['budget'] ?? 0).toDouble(),
      status: json['status'] ?? 'planning',
      days: json['days'] != null
          ? (json['days'] as List).map((e) => TripDayModel.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
    };
  }
}

class TripDayModel {
  final String id;
  final int dayNumber;
  final String? date;
  final String? notes;
  final List<TripActivityModel>? activities;

  TripDayModel({
    required this.id,
    required this.dayNumber,
    this.date,
    this.notes,
    this.activities,
  });

  factory TripDayModel.fromJson(Map<String, dynamic> json) {
    return TripDayModel(
      id: json['id']?.toString() ?? '',
      dayNumber: json['dayNumber'] ?? 0,
      date: json['date'],
      notes: json['notes'],
      activities: json['activities'] != null
          ? (json['activities'] as List)
              .map((e) => TripActivityModel.fromJson(e))
              .toList()
          : null,
    );
  }
}

class TripActivityModel {
  final String id;
  final String title;
  final String? time;
  final String? location;
  final String? description;
  final double? cost;

  TripActivityModel({
    required this.id,
    required this.title,
    this.time,
    this.location,
    this.description,
    this.cost,
  });

  factory TripActivityModel.fromJson(Map<String, dynamic> json) {
    return TripActivityModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      time: json['time'],
      location: json['location'],
      description: json['description'],
      cost: (json['cost'] ?? 0).toDouble(),
    );
  }
}
