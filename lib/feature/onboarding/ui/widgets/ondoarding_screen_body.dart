import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/custom_button.dart';
import 'package:egytravel_app/feature/onboarding/logic/controller/onboarding_controller.dart';
import 'package:egytravel_app/feature/onboarding/ui/widgets/onboarding_page.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreenBody extends StatelessWidget {
  const OnboardingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: const [
              OnboardingPage(
                title: 'Life is short and the world is ',
                highlightedText: 'wide',
                description:
                    'At EgyTravel, we design trusted and memorable educational and travel experiences to the most beautiful destinations around the Egypt.',
                imagePath: Assets.imageOnboarding3,
                pageNumber: 1,
              ),
              OnboardingPage(
                title: 'It’s a big world out there — go ',
                highlightedText: 'explore',
                description:
                    'To make the most of your adventure, all you need is to start your journey wherever your heart leads. We’re waiting for you!',
                imagePath: Assets.imageOnboarding2,
                pageNumber: 2,
              ),
              OnboardingPage(
                title: 'People don’t take trips, ',
                highlightedText: 'trips take people',
                description:
                    'Every journey leaves a mark — let your next adventure begin with EgyTravel.',
                imagePath: Assets.imageOnboarding1,
                pageNumber: 3,
              ),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: controller.pageController, // PageController
          count: 3,
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: AppColor.primary,
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton(
              backgroundColor: AppColor.primary,
              text: controller.currentPage == 2 ? 'Get Started' : 'Next',
              textColor: Colors.black,
              onPressed: controller.nextPage,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
