import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/screen/details.dart';
import 'package:egytravel_app/feature/home/ui/widgets/destination_card.dart';
import 'package:egytravel_app/feature/home/ui/widgets/home_screen_body.dart';
import 'package:egytravel_app/feature/home/ui/widgets/place_card.dart';
import 'package:egytravel_app/feature/profile/ui/screen/profile_screen.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [
    const HomeScreenBody(),
    const ProfileScreen(),
    const HomeScreenBody(),
    const ProfileScreen(),
    const ProfileScreen(),
  ];

    int selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
        key: controller.scaffoldKey,
        body: pages[selectedItem],
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColor.primary,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: AppColor.primary.withValues(alpha: 0.7),
          items: [
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsHome),
              ),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsSearch),
              ),
              label: 'Search',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsExplore),
              ),
              label: 'add',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsExplore),
              ),
              label: 'Explore',
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(Assets.iconsProfile),
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedItem = index;
            });
          },
        ),

    );
  }
}
