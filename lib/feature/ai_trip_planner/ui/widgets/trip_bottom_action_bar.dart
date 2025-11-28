import 'dart:ui';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/trip_itinerary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripBottomActionBar extends StatelessWidget {
  const TripBottomActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Save as draft
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Itinerary saved as draft'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Draft',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm Trip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            //  FloatingActionButton(onPressed: onPressed)
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    final controller = Get.find<TripItineraryController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Your Trip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you ready to proceed with this itinerary?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              '• ${controller.tripDays.length} days trip',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              '• ${controller.destination}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              '• ${controller.budget} budget',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can still modify your trip later',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip confirmed successfully! 🎉'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
              // Navigate to booking or next screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
