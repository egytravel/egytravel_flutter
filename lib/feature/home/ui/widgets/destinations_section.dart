import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/data/model/destination_model.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/destination_card.dart';
import 'package:egytravel_app/feature/explore/ui/screen/explore_screen.dart';
import 'package:get/get.dart';

class DestinationsSection extends StatelessWidget {
  final HomeController controller;

  const DestinationsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Use dummy items for skeletonizer if loading and list is empty
      final list =
          (controller.isLoading.value && controller.destinations.isEmpty)
          ? List.generate(
              4,
              (index) => Destination(id: '', name: 'Loading Name', image: ''),
            )
          : controller.destinations.take(4).toList();

      if (list.isEmpty && !controller.isLoading.value)
        return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Destination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final navController = Get.find<HomeNavigationController>();
                    navController.setBottomTab(1);
                  },
                  child: Text(
                    'Explore',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: list.map((destination) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  child: DestinationCard(destination: destination),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
