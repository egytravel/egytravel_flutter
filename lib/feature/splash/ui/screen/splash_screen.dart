import 'package:egytravel_app/feature/splash/logic/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFDF2E0), Color(0xFFF5E6D3), Color(0xFFEDD5B8)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative rotating circles
            ...List.generate(3, (index) {
              return AnimatedBuilder(
                animation: controller.rotateAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: 100 + (index * 200.0),
                    right: -50 + (index * 30.0),
                    child: Transform.rotate(
                      angle: (controller.rotateAnimation.value + index * 0.3) * 6.28,
                      child: Container(
                        width: 150 - (index * 30.0),
                        height: 150 - (index * 30.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.brown.withOpacity(0.05),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation:controller.mainController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.fadeInAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with pulsing glow
                        AnimatedBuilder(
                          animation: controller.pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: controller.scaleAnimation.value,
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8B6F47)
                                          .withOpacity(
                                            0.3 * controller.pulseAnimation.value,
                                          ),
                                      blurRadius: 40 * controller.pulseAnimation.value,
                                      spreadRadius: 10 * controller.pulseAnimation.value,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFF8B6F47),
                                        width: 3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/image/logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 50),

                        // App name with slide animation
                        Transform.translate(
                          offset: Offset(0, controller.slideAnimation.value),
                          child: Column(
                            children: [
                              const Text(
                                'EgyTravel',
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF2C1810),
                                  letterSpacing: 1.5,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF8B6F47),
                                      Color(0xFFD4AF37),
                                      Color(0xFF8B6F47),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Explore the Land of Pharaohs',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: const Color(
                                    0xFF2C1810,
                                  ).withOpacity(0.7),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom loading section
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: controller.fadeInAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: controller.fadeInAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.brown.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF8B6F47),
                              ),
                              minHeight: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading Experience...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.black.withOpacity(0.4),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
