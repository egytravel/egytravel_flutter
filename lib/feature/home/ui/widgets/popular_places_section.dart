import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/place_card.dart';
import 'package:egytravel_app/feature/home/ui/screen/details.dart';
import 'package:get/get.dart';

class PopularPlacesSection extends StatelessWidget {
  final HomeController controller;

  const PopularPlacesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Places',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const SaintMoritzDetailScreen());
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: controller.places.map((place) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: PlaceCard(place: place),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
