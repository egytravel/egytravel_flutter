import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Home",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 75,
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
            label: 'Explore ',
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
          // Handle button tap
        },
      ),
    );
  }
}
