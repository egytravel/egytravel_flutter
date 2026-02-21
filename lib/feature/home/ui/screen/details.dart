import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controller/saint_moritz_controller.dart';
import '../widgets/details/detail_header.dart';
import '../widgets/details/detail_info_section.dart';
import '../widgets/details/detail_tab_bar.dart';
import '../widgets/details/description_tab.dart';
import '../widgets/details/photos_tab.dart';
import '../widgets/details/reviews_tab.dart';
import '../../../ai_trip_planner/ui/widgets/background_widget.dart';

class SaintMoritzDetailScreen extends StatelessWidget {
  const SaintMoritzDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SaintMoritzController());

    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            DetailHeader(controller: controller),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const DetailInfoSection(),
                    const SizedBox(height: 24),
                    DetailTabBar(controller: controller),
                    const SizedBox(height: 24),
                    Obx(() {
                      switch (controller.selectedTab.value) {
                        case 0:
                          return const DescriptionTab();
                        case 1:
                          return PhotosTab(controller: controller);
                        case 2:
                          return ReviewsTab(controller: controller);
                        default:
                          return const DescriptionTab();
                      }
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
