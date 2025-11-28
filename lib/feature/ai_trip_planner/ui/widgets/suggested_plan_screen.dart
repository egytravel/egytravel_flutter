import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/trip_itinerary_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/trip_app_bar.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/trip_bottom_action_bar.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/trip_itinerary_body.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:egytravel_app/feature/ai_chat/ui/widgets/floating_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripItineraryScreen extends StatelessWidget {
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String budget;
  final List<String> interests;

  const TripItineraryScreen({
    Key? key,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.interests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    final controller = Get.put(TripItineraryController());
    
    // Initialize Data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initData(
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
        interests: interests,
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imageSplashScreen),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.85),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                TripAppBar(destination: destination),
                const Expanded(
                  child: TripItineraryBody(),
                ),
                const TripBottomActionBar(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 110.0),
        child: FloatingChatButton(),
      ),
    );
  }
}
