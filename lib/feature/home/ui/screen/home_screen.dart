import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/screens/icon_add_widget.dart';
import 'package:egytravel_app/feature/booking/ui/screen/booking_screen.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_navigation_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/home_screen_body.dart';
import 'package:egytravel_app/feature/profile/ui/screen/profile_screen.dart';
import 'package:egytravel_app/feature/explore/ui/screen/explore_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late final HomeNavigationController navController;

  final List<Widget> pages = [
    const HomeScreenBody(),
    const ExploreScreen(),
    Container(),
    const BookingScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    navController = Get.put(HomeNavigationController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(() {
      return Scaffold(
        key: controller.scaffoldKey,
        body: Stack(
          children: [
            pages[navController.selectedBottomTab.value],
            CustomFloatingMenu(key: CustomFloatingMenu.menuKey),
          ],
        ),
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: CrystalNavigationBar(
          marginR: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          currentIndex: navController.selectedBottomTab.value,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withValues(alpha: .4),
          borderWidth: 2,
          outlineBorderColor: Colors.white,
          onTap: _handleIndexChanged,
          items: [
            CrystalNavigationBarItem(
              icon: CupertinoIcons.house_fill,
              unselectedIcon: CupertinoIcons.house,
              selectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.map_fill,
              unselectedIcon: CupertinoIcons.map,
              selectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.add_circled_solid,
              unselectedIcon: CupertinoIcons.add,
              selectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.creditcard_fill,
              unselectedIcon: CupertinoIcons.creditcard,
              selectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.person_fill,
              unselectedIcon: CupertinoIcons.person,
              selectedColor: Colors.white,
            ),
          ],
        ),
      );
    });
  }

  void _handleIndexChanged(int index) {
    if (index == 2) {
      // Add button
      CustomFloatingMenu.menuKey.currentState?.toggle();
      return;
    }

    // Close menu if open when switching tabs
    CustomFloatingMenu.menuKey.currentState?.close();

    navController.setBottomTab(index);
  }

  @override
  void dispose() {
    isDialOpen.dispose();
    super.dispose();
  }
}
