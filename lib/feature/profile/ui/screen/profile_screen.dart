import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_header.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_logout_button.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_menu_section.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_quick_actions.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_trips_section.dart';
import 'package:egytravel_app/feature/profile/ui/screen/favorites_screen.dart';
import 'package:egytravel_app/feature/profile/ui/screen/bookings_screen.dart';
import 'package:egytravel_app/feature/profile/ui/screen/travel_history_screen.dart';
import 'package:egytravel_app/feature/profile/ui/screen/personal_info_screen.dart';
import 'package:egytravel_app/feature/profile/ui/screen/security_screen.dart';
import 'package:egytravel_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController());
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF0A1628), Color(0xFF0D1B2E)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: RepaintBoundary(
          child: Obx(() {
            // ── Error state ────────────────────────────────────────────────
            if (controller.hasError.value && !controller.isLoading.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off_rounded,
                          color: Colors.white38, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: controller.fetchProfile,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ── Loading + Success state (Skeletonizer handles both) ────────
            return Skeletonizer(
              enabled: controller.isLoading.value,
              effect: const ShimmerEffect(
                baseColor: Color(0xFF1E2D45),
                highlightColor: Color(0xFF2E4060),
              ),
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  // ── SliverAppBar ────────────────────────────────────────
                  SliverAppBar(
                    expandedHeight: 320,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: const Color(0xFF0A1628),
                    surfaceTintColor: Colors.transparent,
                    title: Obx(() {
                      if (!controller.isScrolled.value) {
                        return const SizedBox.shrink();
                      }
                      final p = controller.profile.value;
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF1E293B),
                            backgroundImage: (p?.profilePhotoUrl != null &&
                                    p!.profilePhotoUrl!.startsWith('http'))
                                ? NetworkImage(p.profilePhotoUrl!) as ImageProvider
                                : const AssetImage(Assets.iconsProfile),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p?.name ?? '...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }),
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeader(
                        profile: controller.profile.value,
                      ),
                      collapseMode: CollapseMode.pin,
                    ),
                  ),

                  // ── Content ─────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Quick Actions
                          const ProfileQuickActions(),
                          const SizedBox(height: 28),

                          // My Trips
                          Obx(() => Skeletonizer(
                                enabled: controller.isLoading.value &&
                                    controller.userTrips.isEmpty,
                                child: ProfileTripsSection(
                                  trips: controller.userTrips.toList(),
                                  onTripTap: controller.navigateToTripDetails,
                                ),
                              )),
                          const SizedBox(height: 28),

                          // Account Settings
                          ProfileMenuSection(
                            title: 'Account Settings',
                            icon: Icons.person_outline_rounded,
                            items: [
                              ProfileMenuItem(
                                icon: Icons.badge_outlined,
                                title: 'Personal Information',
                                subtitle: 'Manage your personal details',
                                onTap: () => Get.to(() => const PersonalInfoScreen()),
                              ),
                              const ProfileMenuDivider(),
                              ProfileMenuItem(
                                icon: Icons.lock_outline_rounded,
                                title: 'Security',
                                subtitle: 'Password and authentication',
                                onTap: () => Get.to(() => const SecurityScreen()),
                              ),
                              const ProfileMenuDivider(),
                              ProfileMenuItem(
                                icon: Icons.notifications_outlined,
                                title: 'Notifications',
                                subtitle: 'Manage notification preferences',
                                onTap: () {},
                                trailing: Obx(() => Switch(
                                      value: controller.pushEnabled.value,
                                      onChanged:
                                          controller.togglePushNotification,
                                      activeColor: const Color(0xFF6366F1),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Travel & Bookings
                          ProfileMenuSection(
                            title: 'Travel & Bookings',
                            icon: Icons.flight_takeoff_rounded,
                            items: [
                              ProfileMenuItem(
                                icon: Icons.calendar_today_outlined,
                                title: 'My Bookings',
                                subtitle: 'View your upcoming trips',
                                onTap: () => Get.to(() => const BookingsScreen()),
                              ),
                              const ProfileMenuDivider(),
                              ProfileMenuItem(
                                icon: Icons.favorite_outline_rounded,
                                title: 'Saved Places',
                                subtitle: 'Places you want to visit',
                                onTap: () => Get.to(() => const FavoritesScreen()),
                                badge: '8',
                              ),
                              const ProfileMenuDivider(),
                              ProfileMenuItem(
                                icon: Icons.history_rounded,
                                title: 'Travel History',
                                subtitle: "Places you've explored",
                                onTap: () => Get.to(() => const TravelHistoryScreen()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Help & Legal
                          ProfileMenuSection(
                            title: 'Help & Legal',
                            icon: Icons.help_outline_rounded,
                            items: [
                              ProfileMenuItem(
                                icon: Icons.info_outline_rounded,
                                title: 'About',
                                subtitle: 'Version 1.0.0',
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          const ProfileLogoutButton(),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
