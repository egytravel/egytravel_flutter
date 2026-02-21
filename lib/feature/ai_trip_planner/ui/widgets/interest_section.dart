import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/glass_container_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/interest_chip_widget.dart';
import 'package:flutter/material.dart';

class InterestsSection extends StatelessWidget {
  final TripController controller;
  const InterestsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final interests = [
      'Pyramids & Pharaonic',
      'Museums',
      'Nightlife & Lounges',
      'Nature & Parks',
      'Marina & Sea',
      'Beaches',
      'Snorkeling & Diving',
      'Nile Cruises',
      'Safari',
      'Theme Parks',
    ];

    final icons = [
      Icons.account_balance,
      Icons.museum,
      Icons.nightlife,
      Icons.nature,
      Icons.sailing,
      Icons.beach_access,
      Icons.scuba_diving,
      Icons.directions_boat,
      Icons.terrain,
      Icons.celebration,
    ];

    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Row(
              children: const [
                Icon(Icons.favorite, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Text('Specific Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Select your interests for a more accurate plan', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(interests.length, (index) {
                return InterestChip(label: interests[index], icon: icons[index], controller: controller);
              }),
            ),
          ],
        ),
      ),
    );
  }
}