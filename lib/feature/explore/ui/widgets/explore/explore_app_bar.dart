import 'dart:ui';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class ExploreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMapPressed;
  final bool isScrolled;

  const ExploreAppBar({
    super.key,
    required this.onMapPressed,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 10 : 0,
          sigmaY: isScrolled ? 10 : 0,
        ),
        child: AppBar(
          backgroundColor: isScrolled
              ? const Color(0xFF0A1628).withValues(alpha: 0.8)
              : Colors.transparent,
          elevation: isScrolled ? 4 : 0,
          centerTitle: true,
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isScrolled ? 1.0 : 0.0,
            child: const Text(
              'Explore Egypt',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: onMapPressed,
              icon: Icon(
                Icons.map_rounded,
                color: isScrolled ? AppColor.primaryColor : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
