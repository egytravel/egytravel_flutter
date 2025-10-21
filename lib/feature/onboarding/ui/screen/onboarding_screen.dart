import 'package:egytravel_app/feature/onboarding/ui/widgets/ondoarding_screen_body.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: OnboardingScreenBody()),
    );
  }
}
