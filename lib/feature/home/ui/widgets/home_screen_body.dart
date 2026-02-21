import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/destinations_section.dart';
import 'package:egytravel_app/feature/home/ui/widgets/hero_carousel.dart';
import 'package:egytravel_app/feature/home/ui/widgets/home_app_bar.dart';
import 'package:egytravel_app/feature/home/ui/widgets/popular_places_section.dart';
import 'package:egytravel_app/feature/home/ui/widgets/quick_actions_section.dart';
import 'package:egytravel_app/feature/home/ui/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A1628).withOpacity(0.0),
            const Color(0xFF0A1628),
            const Color(0xFF0D1B2E),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: HomeAppBar(controller: controller),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroCarousel(controller: controller),
              const SizedBox(height: 8),
              SearchBarWidget(controller: controller),
              const QuickActionsSection(),
              const SizedBox(height: 8),
              PopularPlacesSection(controller: controller),
              DestinationsSection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
