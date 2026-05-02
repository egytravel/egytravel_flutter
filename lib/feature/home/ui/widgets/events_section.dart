import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:egytravel_app/feature/explore/ui/screen/explore_listing_screen.dart';
import 'package:egytravel_app/feature/home/data/model/event_model.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/ui/widgets/event_card.dart';
import 'package:get/get.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final list = controller.events.take(4).toList();

      final displayList = list.isEmpty && controller.isLoading.value
          ? List.generate(2, (index) => null)
          : list;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        // decoration: BoxDecoration(
        //   color: Colors.red.withValues(alpha: 0.1), // Debug color
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(
                      () => const ExploreListingScreen(),
                      arguments: {'type': ExploreItemType.event},
                      transition: Transition.rightToLeftWithFade,
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (displayList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No events found at the moment',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              )
            else
              Column(
                children: displayList.map((event) {
                  if (event == null) {
                    // Dummy event for skeletonizer
                    return EventCard(
                      event: EventModel(
                        id: '0',
                        title: 'Loading Event...',
                        description: 'Loading description...',
                        category: 'Category',
                        location: 'Location',
                        city: 'City',
                        startDate: 'Date',
                        coverImage: '',
                        images: [],
                        tags: [],
                      ),
                    );
                  }
                  return EventCard(event: event);
                }).toList(),
              ),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }
}
