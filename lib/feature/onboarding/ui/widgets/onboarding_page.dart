import 'package:egytravel_app/feature/onboarding/logic/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnboardingPage extends StatelessWidget {
  final String title;
  final String highlightedText;
  final String description;
  final String imagePath;
  final int pageNumber;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.highlightedText,
    required this.description,
    required this.imagePath,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Column(
      children: [
        // Image Container
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Status bar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (pageNumber < 3)
                Positioned(
                  top: 10,
                  right: 10,
                  child: TextButton(
                    onPressed: controller.skipToEnd,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(text: title),
                          TextSpan(
                            text: highlightedText,
                            style: const TextStyle(
                              color: Color(0xFFFF8C42),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFFF8C42),
                              decorationThickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
