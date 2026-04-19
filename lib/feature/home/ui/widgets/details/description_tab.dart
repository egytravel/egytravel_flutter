import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/logic/controller/place_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DescriptionTab extends StatelessWidget {
  const DescriptionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlaceDetailController>();
    final place = controller.place;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColor.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        place.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                place.description ?? 'No description available.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              if (place.facilities != null && place.facilities!.isNotEmpty) ...[
                const Text(
                  'Facilities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        if (place.facilities != null && place.facilities!.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: place.facilities!.map((facility) {
                return _buildFacilityChip(_getFacilityIcon(facility), facility);
              }).toList(),
            ),
          ),
        SizedBox(height: MediaQuery.heightOf(context) * 0.08),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  IconData _getFacilityIcon(String facility) {
    String f = facility.toLowerCase();
    if (f.contains('wifi')) return Icons.wifi;
    if (f.contains('pool')) return Icons.pool;
    if (f.contains('restau')) return Icons.restaurant;
    if (f.contains('gym')) return Icons.fitness_center;
    if (f.contains('parking')) return Icons.local_parking;
    if (f.contains('tour')) return Icons.tour;
    if (f.contains('shop')) return Icons.shopping_bag;
    if (f.contains('cafe')) return Icons.coffee;
    return Icons.check_circle_outline;
  }

  Widget _buildFacilityChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColor.primaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
