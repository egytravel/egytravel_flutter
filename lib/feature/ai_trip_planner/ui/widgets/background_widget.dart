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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
