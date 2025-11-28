import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/background_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/budget_selection.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/button_start_panning.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/data_selector_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/estination_input_widget.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/header_ai_trip.dart';
import 'package:egytravel_app/feature/ai_trip_planner/ui/widgets/interest_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanTripScreen extends GetView<TripController> {
  const PlanTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: GetBuilder<TripController>(
                builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(onClose: () => Navigator.pop(context)),
                      const SizedBox(height: 32),
                      DestinationInput(controller: controller.destinationController),
                      const SizedBox(height: 16),
                      DateSelector(
                        startDate: controller.startDate,
                        endDate: controller.endDate,
                        onDateSelected: (start, end) {
                          controller.setStartDate(start);
                          controller.setEndDate(end);
                        },
                      ),
                      const SizedBox(height: 16),
                      BudgetSection(controller: controller),
                      const SizedBox(height: 16),
                      InterestsSection(controller: controller),
                      const SizedBox(height: 32),
                      StartPlanningButton(controller: controller),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}