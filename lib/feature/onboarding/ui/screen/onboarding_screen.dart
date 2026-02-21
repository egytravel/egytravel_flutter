// import 'package:flutter/material.dart';
// import 'package:egytravel_app/generated/assets.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _currentIndex = 0;
//
//   final List<String> images = [
//     Assets.imageOnboarding1,
//     Assets.imageOnboarding2,
//     Assets.imageOnboarding3,
//   ];
//
//   final List<String> titles = [
//     "Embrace the Mystique",
//     "Journey Through Time",
//     "Uncover Ancient Secrets",
//   ];
//
//   final List<String> subtitles = [
//     "Discover the land of the Pharaohs and explore ancient wonders.",
//     "Walk through temples, history, and stories carved in stone.",
//     "Experience the mysteries that shaped civilizations.",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           /// ---------------- الخلفية المتغيرة مع السلايد ----------------
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 600),
//             child: SizedBox.expand(
//               key: ValueKey(images[_currentIndex]),
//               child: Image.asset(
//                 images[_currentIndex],
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//
//
//           PageView.builder(
//             controller: _controller,
//             itemCount: images.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       titles[index],
//                       style: const TextStyle(
//                         fontSize: 26,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         height: 1.2,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       subtitles[index],
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white.withOpacity(0.9),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     /// ---------------- نقاط المؤشر ----------------
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(images.length, (dotIndex) {
//                         return AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           width: _currentIndex == dotIndex ? 14 : 8,
//                           height: _currentIndex == dotIndex ? 14 : 8,
//                           decoration: BoxDecoration(
//                             color: _currentIndex == dotIndex
//                                 ? Colors.white
//                                 : Colors.white54,
//                             shape: BoxShape.circle,
//                           ),
//                         );
//                       }),
//                     ),
//
//                     const SizedBox(height: 40),
//
//                     /// ---------------- الزرار السفلي ----------------
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFF2A900),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (_currentIndex == images.length - 1) {
//                             // GET STARTED ACTION
//                           } else {
//                             _controller.nextPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.easeInOut,
//                             );
//                           }
//                         },
//                         child: Text(
//                           _currentIndex == images.length - 1
//                               ? "Get started"
//                               : "Next",
//                           style: const TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 60),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> images = [
    Assets.imageOnboarding1,
    Assets.imageOnboarding2,
    Assets.imageOnboarding3,
  ];

  final List<String> titles = [
    "Embrace the Mystique",
    "Journey Through Time",
    "Uncover Ancient Secrets",
  ];

  final List<String> subtitles = [
    "Discover the land of the Pharaohs and explore ancient wonders.",
    "Walk through temples, history, and stories carved in stone.",
    "Experience the mysteries that shaped civilizations.",
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Slide animation controller
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start initial animation
    _fadeController.forward();
    _slideController.forward();
  }

  void _animateContent() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// ---------------- Animated Background ----------------
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey(images[_currentIndex]),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(images[_currentIndex]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ---------------- Content ----------------
          PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _animateContent();
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ---------------- Animated Title ----------------
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Text(
                          titles[index],
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ---------------- Animated Subtitle ----------------
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 0.4),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _slideController,
                                curve: const Interval(
                                  0.2,
                                  1.0,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            ),
                        child: Text(
                          subtitles[index],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// ---------------- Animated Dots Indicator ----------------
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _fadeController,
                          curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (dotIndex) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: _currentIndex == dotIndex ? 32 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _currentIndex == dotIndex
                                  ? const Color(0xFFF2A900)
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// ---------------- Animated Button ----------------
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _fadeController,
                          curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
                        ),
                      ),
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _slideController,
                                curve: const Interval(
                                  0.4,
                                  1.0,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            ),
                        child: SizedBox(
                          width: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF2A900),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 8,
                                shadowColor: const Color(
                                  0xFFF2A900,
                                ).withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (_currentIndex == images.length - 1) {
                                  // GET STARTED ACTION
                                  // Navigator.pushReplacement(context, ...);

                                  Get.offAllNamed(Routes.loginScreen);
                                } else {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _currentIndex == images.length - 1
                                      ? "Get Started"
                                      : "Next",
                                  key: ValueKey(
                                    _currentIndex == images.length - 1,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              );
            },
          ),

          /// ---------------- Skip Button (Top Right) ----------------
          if (_currentIndex < images.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: () {
                    _controller.animateToPage(
                      images.length - 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // child: TextButton(
                //   onPressed: () {
                //     _controller.animateToPage(
                //       images.length - 1,
                //       duration: const Duration(milliseconds: 500),
                //       curve: Curves.easeInOut,
                //     );
                //   },
                //   style: TextButton.styleFrom(
                //     backgroundColor: Colors.white.withOpacity(0.2),
                //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                //   child: const Text(
                //     "Skip",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ),
            ),
        ],
      ),
    );
  }
}
