import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class ExploreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMapPressed;

  const ExploreAppBar({super.key, required this.onMapPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'Explore Egypt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
