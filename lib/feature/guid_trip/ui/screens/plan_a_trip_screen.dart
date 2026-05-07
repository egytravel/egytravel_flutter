import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/data_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanATripScreen extends StatelessWidget {
  const PlanATripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuideTripController>(
      init: GuideTripController(),
      builder: (controller) {
        return GlassyBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────────────
                    const Row(
                      children: [
                        CustomBackButton(),
                        SizedBox(width: 12),
                        Text(
                          'Create Your Trip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 44),
                      child: Text(
                        'Plan your perfect journey',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Section label ───────────────────────────────────────
                    _SectionLabel(label: 'Trip Details', icon: Icons.edit_note),

                    const SizedBox(height: 12),

                    // ── Title field ─────────────────────────────────────────
                    _GlassTextField(
                      controller: controller.titleController,
                      label: 'Trip Title',
                      hint: 'e.g. Summer Adventure in Cairo',
                      icon: Icons.title_rounded,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 14),

                    // ── Description field ───────────────────────────────────
                    _GlassTextField(
                      controller: controller.descriptionController,
                      label: 'Description (optional)',
                      hint: 'Describe your trip goals, activities or vibe…',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 28),

                    // ── Section label ───────────────────────────────────────
                    _SectionLabel(label: 'Travel Dates', icon: Icons.date_range),

                    const SizedBox(height: 12),

                    // ── Date picker ─────────────────────────────────────────
                    GetBuilder<GuideTripController>(
                      builder: (_) => DateSelector(
                        startDate: controller.startDate,
                        endDate: controller.endDate,
                        onDateSelected: (start, end) {
                          controller.setStartDate(start);
                          controller.setEndDate(end);
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Create button ───────────────────────────────────────
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.createGuide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            disabledBackgroundColor:
                                Colors.orange.withOpacity(0.5),
                            padding:
                                const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 8,
                            shadowColor: Colors.orange.withOpacity(0.5),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.rocket_launch,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Create Trip',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              cursorColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
