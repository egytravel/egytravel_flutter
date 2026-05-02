import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';

class GuideAppBar extends StatelessWidget {
  final String destination;

  const GuideAppBar({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CustomBackButton(onPressed: () => Navigator.of(context).pop()),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Guide Trip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  destination,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () => Get.find<GuideTripController>().shareTrip(),
            ),
          ),
        ],
      ),
    );
  }
}
