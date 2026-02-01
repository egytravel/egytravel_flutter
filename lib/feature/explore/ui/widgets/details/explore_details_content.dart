import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:flutter/material.dart';

class ExploreDetailsContent extends StatelessWidget {
  final ExploreItemModel item;

  const ExploreDetailsContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    item.rating.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Location
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColor.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              item.location,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Description
        const Text(
          "Description",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Experience the magic of ${item.title}. Just a short distance from ${item.location}, this destination offers a unique blend of culture, history, and modern amenities perfect for travelers seeking adventure and relaxation.",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
