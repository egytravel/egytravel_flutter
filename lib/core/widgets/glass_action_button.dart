import 'package:flutter/material.dart';
import 'dart:ui';

class GlassActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double iconSize;
  final EdgeInsets padding;

  const GlassActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
    this.iconSize = 20,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(icon, size: iconSize, color: color),
          ),
        ),
      ),
    );
  }
}
