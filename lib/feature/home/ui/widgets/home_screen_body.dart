import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/categories_section.dart';
import 'package:egytravel_app/feature/home/ui/widgets/destinations_section.dart';
import 'package:egytravel_app/feature/home/ui/widgets/hero_carousel.dart';
import 'package:egytravel_app/feature/home/ui/widgets/home_app_bar.dart';
import 'package:egytravel_app/feature/home/ui/widgets/popular_places_section.dart';
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
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: const HomeAppBar(),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroCarousel(controller: controller),
              SearchBarWidget(controller: controller),
              CategoriesSection(controller: controller),
              PopularPlacesSection(controller: controller),
              DestinationsSection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
