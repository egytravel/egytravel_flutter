import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../logic/controller/saint_moritz_controller.dart';
import 'review_card.dart';
import 'rating_bar_widget.dart';
import 'add_review_dialog.dart';

class ReviewsTab extends StatelessWidget {
  final SaintMoritzController controller;

  const ReviewsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    const Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return const Icon(
                          Icons.star,
                          color: Color(0xFFFF7675),
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '2.5k reviews',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
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
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
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
