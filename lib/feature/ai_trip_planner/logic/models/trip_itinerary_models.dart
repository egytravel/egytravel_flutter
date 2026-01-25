import 'package:flutter/material.dart';

class DayItinerary {
  final int dayNumber;
  final DateTime date;
  List<Activity> activities;
  String hotel;
  Flight? flight;

  DayItinerary({
    required this.dayNumber,
    required this.date,
    required this.activities,
    required this.hotel,
    this.flight,
  });
}

class Activity {
  final String time;
  final String title;
  final IconData icon;
  final String description;

  Activity({
    required this.time,
    required this.title,
    required this.icon,
    required this.description,
  });
}

class Flight {
  final String from;
  final String to;
  final String time;
  final String flightNumber;

  Flight({
    required this.from,
    required this.to,
    required this.time,
    required this.flightNumber,
  });
}
