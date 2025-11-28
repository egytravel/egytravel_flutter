import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:flutter/material.dart';

class StartPlanningButton extends StatelessWidget {
  final TripController controller;
  const StartPlanningButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (controller.validateInputs(context)) {
            controller.navigateToTripScreen(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.orange.withOpacity(0.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Text('Start planning', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}