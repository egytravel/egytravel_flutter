import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/data_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:ui';

class AiTripPlannerScreen extends GetView<TripController> {
  const AiTripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomBackButton(),
          ),
          title: const Text(
            'plane  a new trip',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Build an itinerary and map out your upcoming\ntravel plans',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              
              // City Selection
              _buildSectionTitle('Where to?', Icons.location_city),
              const SizedBox(height: 12),
              _buildCitySelector(),
              const SizedBox(height: 25),

              // Dates Selection
              Obx(() => DateSelector(
                    startDate: controller.startDate.value,
                    endDate: controller.endDate.value,
                    onDateSelected: (start, end) {
                      controller.startDate.value = start;
                      controller.endDate.value = end;
                    },
                  )),
              const SizedBox(height: 25),

              // Budget
              _buildSectionTitle('Trip Budget (Estimated)', Icons.account_balance_wallet_rounded),
              const SizedBox(height: 12),
              _buildBudgetSelector(),
              const SizedBox(height: 25),

              // Interests
              _buildSectionTitle('Specific Interests', Icons.favorite_rounded),
              const SizedBox(height: 12),
              _buildInterestsSelector(),
              const SizedBox(height: 40),

              // Generate Button
              _buildGenerateButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColor.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.orange, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller.cityController,
                  onChanged: controller.onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., Cairo, Luxor, Alexandria',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Obx(() => controller.isSearching.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
        
        // Suggestions List
        Obx(() {
          if (controller.suggestions.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A3D),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: controller.suggestions.length,
              separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
              itemBuilder: (context, index) {
                final suggestion = controller.suggestions[index];
                return ListTile(
                  leading: const Icon(Icons.location_city, color: Colors.white54, size: 20),
                  title: Text(suggestion.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: Text(suggestion.country ?? 'Egypt', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  onTap: () => controller.selectProvince(suggestion),
                );
              },
            ),
          );
        }),
      ],
    );
  }


  Widget _buildInterestsSelector() {
    return Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.availableInterests.map((interest) {
            final isSelected = controller.selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () => controller.toggleInterest(interest),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getInterestIcon(interest),
                      size: 16,
                      color: isSelected ? Colors.orange : Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  IconData _getInterestIcon(String interest) {
    switch (interest) {
      case 'Pyramids & Pharaonic': return Icons.account_balance;
      case 'Museums': return Icons.museum;
      case 'Nightlife & Lounges': return Icons.nightlife;
      case 'Nature & Parks': return Icons.nature;
      case 'Marina & Sea': return Icons.sailing;
      case 'Beaches': return Icons.beach_access;
      case 'Snorkeling & Diving': return Icons.scuba_diving;
      case 'Nile Cruises': return Icons.directions_boat;
      case 'Safari': return Icons.terrain;
      case 'Theme Parks': return Icons.celebration;
      default: return Icons.explore;
    }
  }

  Widget _buildBudgetSelector() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.availableBudgets.map((budget) {
            final isSelected = controller.selectedBudget.value == budget;
            final label = budget == 'low' ? 'Budget' : budget == 'medium' ? 'Medium' : 'Luxury';
            return GestureDetector(
              onTap: () => controller.updateBudget(budget),
              child: Container(
                width: Get.width * 0.28,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      budget == 'low'
                          ? Icons.savings
                          : budget == 'medium'
                              ? Icons.account_balance
                              : Icons.diamond,
                      color: isSelected ? Colors.orange : Colors.white54,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildGenerateButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.primary, Color(0xFFE07A1E)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : () => controller.generateTrip(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Generate Itinerary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
