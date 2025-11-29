import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/background_widget.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:egytravel_app/feature/guid_trip/ui/widgets/day_input_card.dart';
import 'package:egytravel_app/feature/guid_trip/ui/widgets/guide_app_bar.dart';
import 'package:egytravel_app/feature/guid_trip/ui/widgets/guide_bottom_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class GuideDetailsScreen extends GetView<GuideTripController> {
  const GuideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          SafeArea(
            child: Column(
              children: [
                GuideAppBar(destination: controller.destinationController.text),
                Expanded(
                  child: Obx(
                    () => NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        controller.updateFabVisibility(notification.direction);
                        return true;
                      },
                      child: ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.days.length,
                        itemBuilder: (context, index) {
                          return DayInputCard(day: controller.days[index]);
                        },
                      ),
                    ),
                  ),
                ),
                const GuideBottomActionBar(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => AnimatedScale(
          scale: controller.isFabVisible.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: FloatingActionButton(
              onPressed: controller.addDay,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
