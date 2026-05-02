import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/data_selector_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/estination_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanATripScreen extends StatelessWidget {
  const PlanATripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GuideTripController());

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CustomBackButton(),
                    SizedBox(width: 12),
                    Text(
                      'Create Your Plain a trip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                DestinationInput(controller: controller.destinationController),
                Obx(() {
                  if (controller.suggestions.isEmpty) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: controller.suggestions.map((s) => ListTile(
                        title: Text(s, style: const TextStyle(color: Colors.white)),
                        onTap: () => controller.selectDestination(s),
                        dense: true,
                      )).toList(),
                    ),
                  );
                }),
                const SizedBox(height: 16),
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
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.createGuide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Guide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
  }
}
