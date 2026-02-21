import 'package:egytravel_app/generated/assets.dart';
import 'package:egytravel_app/feature/profile/logic/controller/profile_controller.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_header.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_logout_button.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_menu_section.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_quick_actions.dart';
import 'package:egytravel_app/feature/profile/ui/widgets/profile_trips_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use lazyPut to prevent duplicate controller instances during hot reload
    Get.lazyPut(() => ProfileController());
    final controller = Get.find<ProfileController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A1628).withOpacity(0.0),
            const Color(0xFF0A1628),
            const Color(0xFF0D1B2E),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // Dynamic App Bar with Profile Header
            Obx(() {
              final opacity = controller.scrollOpacity.value;
              final isFullyScrolled = controller.isScrolled.value;

              return SliverAppBar(
                expandedHeight: 320,
                floating: false,
                pinned: true,
                elevation: isFullyScrolled ? 1 : 0,
                backgroundColor: Color.lerp(
                  Colors.transparent,
                  const Color(0xFF0A1628).withOpacity(0.9),
                  opacity,
                ),
                surfaceTintColor: Colors.transparent,
                // Show name in app bar when fully scrolled
                title: AnimatedOpacity(
                  opacity: isFullyScrolled ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(Assets.iconsProfile),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'John Traveler',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  background: ProfileHeader(),
                ),
              );
            }),

            // Content Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Quick Actions Grid
                  const ProfileQuickActions(),

                  const SizedBox(height: 28),

                  // My Trips Section
                  Obx(
                    () => ProfileTripsSection(
                      trips: controller.userTrips.toList(),
                      onTripTap: (trip) =>
                          controller.navigateToTripDetails(trip),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Menu Sections
                  ProfileMenuSection(
                    title: 'Account Settings',
                    icon: Icons.person_outline_rounded,
                    items: [
                      ProfileMenuItem(
                        icon: Icons.badge_outlined,
                        title: 'Personal Information',
                        subtitle: 'Manage your personal details',
                        onTap: () {},
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Security',
                        subtitle: 'Password and authentication',
                        onTap: () {},
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage notification preferences',
                        onTap: () {},
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: const Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ProfileMenuSection(
                    title: 'Travel & Bookings',
                    icon: Icons.flight_takeoff_rounded,
                    items: [
                      ProfileMenuItem(
                        icon: Icons.calendar_today_outlined,
                        title: 'My Bookings',
                        subtitle: 'View your upcoming trips',
                        onTap: () {},
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuItem(
                        icon: Icons.favorite_outline_rounded,
                        title: 'Saved Places',
                        subtitle: 'Places you want to visit',
                        onTap: () {},
                        badge: '8',
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Travel History',
                        subtitle: 'Places you\'ve explored',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

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

                  // Logout Button
                  const ProfileLogoutButton(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
