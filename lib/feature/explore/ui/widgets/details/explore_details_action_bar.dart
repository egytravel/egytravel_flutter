import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreDetailsActionBar extends StatelessWidget {
  final String price;

  const ExploreDetailsActionBar({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price",
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomButton(
              text: "Book Now",
              backgroundColor: AppColor.primary,
              textColor: Colors.white,
              onPressed: () {
                Get.snackbar(
                  "Booking",
                  "Booking feature coming soon!",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
