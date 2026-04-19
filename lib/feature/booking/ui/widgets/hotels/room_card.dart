import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/booking/data/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class RoomCard extends StatelessWidget {
  final RoomModel room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Room Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColor.primaryColor.withValues(alpha: 0.3),
                            AppColor.primaryColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          room.imageUrl,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Room Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.roomType,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 14,
                                color: Colors.white60,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Max ${room.maxGuests} guests',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${room.pricePerNight.toStringAsFixed(0)}/night',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Features
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.features.take(4).map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Select Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: room.isAvailable
                        ? () {
                            showSuccess('${room.roomType} added to booking');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.withValues(
                        alpha: 0.3,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      room.isAvailable ? 'Select Room' : 'Not Available',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
