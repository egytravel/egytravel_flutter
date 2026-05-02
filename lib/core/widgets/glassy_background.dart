import 'package:flutter/material.dart';

class GlassyBackground extends StatelessWidget {
  final Widget child;

  const GlassyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A1628), // Made opaque to fix scrolling glitch
            Color(0xFF0A1628),
            Color(0xFF0D1B2E),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
