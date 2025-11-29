import 'dart:developer';

import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/screens/icon_add_widget.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';
import 'package:egytravel_app/feature/home/ui/widgets/home_screen_body.dart';
import 'package:egytravel_app/feature/profile/ui/screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _SelectedTab { home, favorite, add, search, person }

class _HomeScreenState extends State<HomeScreen> {
  /// 🔥 متغير ال BottomNav
  _SelectedTab _selectedTab = _SelectedTab.home;

  /// 🔥 لو هتستخدم SpeedDial (اختياري)
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  List<Widget> pages = [
    const HomeScreenBody(),
    const HomeScreenBody(),
    Container(),
    const ProfileScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      key: controller.scaffoldKey,
      body: Stack(
        children: [
          pages[_SelectedTab.values.indexOf(_selectedTab)],
          CustomFloatingMenu(key: CustomFloatingMenu.menuKey),
        ],
      ),


      backgroundColor: Colors.transparent,
      extendBody: true,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: CrystalNavigationBar(
          marginR: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.4),
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
      ),
    );
  }

  /// 🔥 هنا بنغيّر ال Tab
  void _handleIndexChanged(int index) {
    if (_SelectedTab.values[index] == _SelectedTab.add) {
      // افتح المينيو بدل ما تغير الصفحة
      CustomFloatingMenu.menuKey.currentState?.toggle();
      return;
    }

    // Close menu if open when switching tabs
    CustomFloatingMenu.menuKey.currentState?.close();

    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  @override
  void dispose() {
    isDialOpen.dispose();
    super.dispose();
  }
}
