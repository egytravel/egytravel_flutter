import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/wallet/logic/controller/wallet_controller.dart';
import 'package:egytravel_app/feature/wallet/ui/screens/trip_expenses_screen.dart';
import 'package:egytravel_app/feature/wallet/ui/widgets/wallet_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Wallet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Track your trip expenses',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Wallet Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF818CF8),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Trips List Header
                Row(
                  children: [
                    const Icon(
                      Icons.luggage_rounded,
                      size: 18,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Your Trips',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Obx(() {
                      final trips = controller.trips;
                      return Text(
                        '${trips.length} ${trips.length == 1 ? 'trip' : 'trips'}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // Trips List
                Expanded(
                  child: Obx(() {
                    final trips = controller.trips;

                    if (trips.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return Obx(() {
                          final total = controller.getTotalForTrip(trip.id);
                          return WalletTripCard(
                            trip: trip,
                            totalExpenses: total,
                            onTap: () {
                              Get.to(
                                () => TripExpensesScreen(trip: trip),
                                transition: Transition.cupertino,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                          );
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No trips yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create a trip first to start tracking\nyour expenses.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
