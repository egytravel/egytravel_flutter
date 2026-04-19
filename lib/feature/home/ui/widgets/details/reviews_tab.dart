import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egytravel_app/feature/home/logic/controller/place_detail_controller.dart';
import 'review_card.dart';
import 'rating_bar_widget.dart';
import 'add_review_dialog.dart';

class ReviewsTab extends StatelessWidget {
  final PlaceDetailController controller;

  const ReviewsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final place = controller.place;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      place.rating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < place.rating.floor() ? Icons.star : Icons.star_border,
                          color: AppColor.gold,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${place.reviewCount ?? 0} reviews',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar('Excellent', 5, 0.8),
                      _buildRatingBar('Good', 4, 0.15),
                      _buildRatingBar('Average', 3, 0.03),
                      _buildRatingBar('Poor', 2, 0.01),
                      _buildRatingBar('Bad', 1, 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.dialog(AddReviewDialog(controller: controller)),
              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
              label: const Text(
                'Write a Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.reviews.length,
              itemBuilder: (context, index) {
                return ReviewCard(review: controller.reviews[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, int stars, double percentage) {
    return RatingBarWidget(label: label, stars: stars, percentage: percentage);
  }
}

