import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/background_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/data_selector_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/estination_input_widget.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideTripScreen extends StatelessWidget {
  const GuideTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GuideTripController());

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'Create Your Guide',
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
        ],
      ),
    );
  }
}
