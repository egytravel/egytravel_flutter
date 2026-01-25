import 'package:egytravel_app/feature/ai_trip_planner/logic/models/trip_itinerary_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class TripItineraryController extends GetxController {
  late String destination;
  late DateTime startDate;
  late DateTime endDate;
  late String budget;
  late List<String> interests;

  List<DayItinerary> tripDays = [];
  bool isLoading = true;
  int selectedDayIndex = 0;
  final isChatVisible = true.obs;

  void updateChatVisibility(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse) {
      if (isChatVisible.value) isChatVisible.value = false;
    } else if (direction == ScrollDirection.forward) {
      if (!isChatVisible.value) isChatVisible.value = true;
    }
  }

  void initData({
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required String budget,
    required List<String> interests,
  }) {
    this.destination = destination;
    this.startDate = startDate;
    this.endDate = endDate;
    this.budget = budget;
    this.interests = interests;
    selectedDayIndex = 0;
    _generateItinerary();
  }

  Future<void> _generateItinerary() async {
    isLoading = true;
    update();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    int totalDays = endDate.difference(startDate).inDays + 1;
    List<DayItinerary> days = [];

    for (int i = 0; i < totalDays; i++) {
      DateTime currentDay = startDate.add(Duration(days: i));
      days.add(_generateDayItinerary(i + 1, currentDay, totalDays));
    }

    tripDays = days;
    isLoading = false;
    update();
  }

  DayItinerary _generateDayItinerary(
    int dayNumber,
    DateTime date,
    int totalDays,
  ) {
    List<Activity> activities = [];
    String hotel = '';
    Flight? flight;

    // Arrival day - has flight
    if (dayNumber == 1) {
      flight = Flight(
        from: 'Cairo International Airport',
        to: destination,
        time: '08:00 AM',
        flightNumber: 'MS ${100 + dayNumber}',
      );

      activities = [
        Activity(
          time: '12:00 PM',
          title: 'Check-in at Hotel',
          icon: Icons.hotel,
          description: 'Arrival and hotel check-in',
        ),
        Activity(
          time: '03:00 PM',
          title: 'City Tour',
          icon: Icons.location_city,
          description: 'Explore the main attractions',
        ),
        Activity(
          time: '07:00 PM',
          title: 'Welcome Dinner',
          icon: Icons.restaurant,
          description: 'Traditional local cuisine',
        ),
      ];
      hotel = _getHotelName(budget);
    }
    // Departure day - has flight
    else if (dayNumber == totalDays) {
      flight = Flight(
        from: destination,
        to: 'Cairo International Airport',
        time: '06:00 PM',
        flightNumber: 'MS ${200 + dayNumber}',
      );

      activities = [
        Activity(
          time: '08:00 AM',
          title: 'Breakfast & Check-out',
          icon: Icons.breakfast_dining,
          description: 'Final breakfast at hotel',
        ),
        Activity(
          time: '10:00 AM',
          title: 'Last Minute Shopping',
          icon: Icons.shopping_bag,
          description: 'Souvenirs and local products',
        ),
        Activity(
          time: '02:00 PM',
          title: 'Airport Transfer',
          icon: Icons.local_airport,
          description: 'Head to airport for departure',
        ),
      ];
      hotel = _getHotelName(budget);
    }
    // Regular days
    else {
      activities = _getActivitiesForDay(dayNumber);
      hotel = _getHotelName(budget);
    }

    return DayItinerary(
      dayNumber: dayNumber,
      date: date,
      activities: activities,
      hotel: hotel,
      flight: flight,
    );
  }

  List<Activity> _getActivitiesForDay(int dayNumber) {
    // Different activities based on user interests
    List<Activity> baseActivities = [
      Activity(
        time: '09:00 AM',
        title: 'Morning Adventure',
        icon: Icons.wb_sunny,
        description: 'Start your day with exciting activities',
      ),
      Activity(
        time: '12:30 PM',
        title: 'Lunch Break',
        icon: Icons.restaurant_menu,
        description: 'Enjoy local delicacies',
      ),
      Activity(
        time: '02:30 PM',
        title: 'Afternoon Exploration',
        icon: Icons.explore,
        description: 'Discover hidden gems',
      ),
      Activity(
        time: '06:00 PM',
        title: 'Evening Entertainment',
        icon: Icons.nightlife,
        description: 'Relaxation and fun',
      ),
      Activity(
        time: '08:00 PM',
        title: 'Dinner Time',
        icon: Icons.dinner_dining,
        description: 'Fine dining experience',
      ),
    ];

    // Customize activities based on interests
    if (interests.contains('Pyramids & Pharaonic')) {
      baseActivities[0] = Activity(
        time: '09:00 AM',
        title: 'Pyramids Visit',
        icon: Icons.account_balance,
        description: 'Explore the ancient pyramids',
      );
    }

    if (interests.contains('Beaches')) {
      baseActivities[2] = Activity(
        time: '02:30 PM',
        title: 'Beach Time',
        icon: Icons.beach_access,
        description: 'Relax at the beautiful beach',
      );
    }

    if (interests.contains('Museums')) {
      baseActivities[0] = Activity(
        time: '09:00 AM',
        title: 'Museum Tour',
        icon: Icons.museum,
        description: 'Visit historical museum',
      );
    }

    return baseActivities;
  }

  String _getHotelName(String budget) {
    switch (budget) {
      case 'Luxury':
        return 'Grand Luxury Resort & Spa';
      case 'Medium':
        return 'Comfort Inn & Suites';
      case 'Budget':
        return 'Cozy Budget Hotel';
      default:
        return 'Comfort Inn & Suites';
    }
  }

  void selectDay(int index) {
    selectedDayIndex = index;
    update();
  }

  void updateActivity(int dayIndex, int activityIndex, Activity newActivity) {
    tripDays[dayIndex].activities[activityIndex] = newActivity;
    update();
  }

  void updateHotel(int dayIndex, String newHotel) {
    tripDays[dayIndex].hotel = newHotel;
    update();
  }

  void updateFlight(int dayIndex, Flight newFlight) {
    tripDays[dayIndex].flight = newFlight;
    update();
  }
}
