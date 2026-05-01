import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget? child;
  const BackgroundImage({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/Splash_Screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4), // Reduced opacity since blur adds darkness
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
