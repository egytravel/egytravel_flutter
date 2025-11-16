// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/theme/app_color.dart';
// import '../../logic/controller/trip_planner_controller.dart';
// import '../widgets/destination_selector.dart';
// import '../widgets/date_selector.dart';
// import '../widgets/budget_selector.dart';
// import '../widgets/generate_plan_button.dart';
// import '../widgets/itinerary_list.dart';
// import '../widgets/papyrus_background.dart';
//
// class TripPlannerScreen extends StatelessWidget {
//   const TripPlannerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Try to find existing controller, if not found, create one
//     TripPlannerController controller;
//     try {
//       controller = Get.find<TripPlannerController>();
//     } catch (e) {
//       controller = Get.put(TripPlannerController());
//     }
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Papyrus/Sand texture background
//           const SimplePapyrusBackground(),
//
//           // Main content
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     _buildHeader(),
//                     const SizedBox(height: 32),
//
//                     // Trip Planning Form
//                     _buildPlanningForm(controller),
//                     const SizedBox(height: 32),
//
//                     // Generate Plan Button
//                     const GeneratePlanButton(),
//                     const SizedBox(height: 32),
//
//                     // Generated Itinerary
//                     Obx(() => controller.showItinerary.value
//                         ? const ItineraryList()
//                         : const SizedBox()),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColor.primary,
//                     AppColor.primary.withOpacity(0.8),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColor.primary.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.map,
//                 color: Colors.white,
//                 size: 28,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'AI Trip Planner',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     //  color: AppColor.hieroglyphBrown,
//                       shadows: [
//                         Shadow(
//                           color: AppColor.primary.withOpacity(0.3),
//                           offset: const Offset(0, 2),
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     'Craft Your Perfect Egyptian Adventure',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.brown.shade600,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPlanningForm(TripPlannerController controller) {
//     return Column(
//       children: [
//         // Destination Selector
//         const DestinationSelector(),
//         const SizedBox(height: 20),
//
//         // Date Selectors
//         Row(
//           children: [
//             Expanded(
//               child: DateSelector(
//                 title: 'Start Date',
//                 selectedDate: controller.selectedStartDate,
//                 onTap: () => controller.selectStartDate(Get.context!),
//                 icon: Icons.flight_takeoff,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: DateSelector(
//                 title: 'End Date',
//                 selectedDate: controller.selectedEndDate,
//                 onTap: () => controller.selectEndDate(Get.context!),
//                 icon: Icons.flight_land,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//
//         // Budget Selector
//         const BudgetSelector(),
//         const SizedBox(height: 20),
//
//         // Trip Duration Display
//         Obx(() => controller.tripDuration > 0
//             ? Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(
//                     color: AppColor.primary.withOpacity(0.3),
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColor.primary.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.schedule,
//                       color: AppColor.primary,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Trip Duration: ${controller.tripDuration} days',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       //  color: AppColor.hieroglyphBrown,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : const SizedBox()),
//       ],
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../logic/controller/trip_planner_controller.dart';
// import '../widgets/destination_selector.dart';
// import '../widgets/date_selector.dart';
// import '../widgets/budget_selector.dart';
// import '../widgets/generate_plan_button.dart';
// import '../widgets/itinerary_list.dart';
//
// class TripPlannerScreen extends StatelessWidget {
//   const TripPlannerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<TripPlannerController>();
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: CustomScrollView(
//         slivers: [
//           // Custom AppBar with gradient
//           SliverAppBar(
//             expandedHeight: 200,
//             floating: false,
//             pinned: true,
//             backgroundColor: Colors.orange,
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: false,
//               title: const Text(
//                 'AI Trip Planner',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.orange,
//                           Colors.deepOrange,
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 60,
//                     left: 16,
//                     right: 16,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.map,
//                                 color: Colors.white,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             const Expanded(
//                               child: Text(
//                                 'Craft Your Perfect Egyptian Adventure',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Main content
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 8),
//
//                   // Trip Planning Form Card
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Destination Selector
//                         const DestinationSelector(),
//                         const SizedBox(height: 20),
//
//                         // Date Selectors
//                         Row(
//                           children: [
//                             Expanded(
//                               child: DateSelector(
//                                 title: 'Start Date',
//                                 selectedDate: controller.selectedStartDate,
//                                 onTap: () => controller.selectStartDate(Get.context!),
//                                 icon: Icons.flight_takeoff,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: DateSelector(
//                                 title: 'End Date',
//                                 selectedDate: controller.selectedEndDate,
//                                 onTap: () => controller.selectEndDate(Get.context!),
//                                 icon: Icons.flight_land,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//
//                         // Budget Selector
//                         const BudgetSelector(),
//                         const SizedBox(height: 20),
//
//                         // Trip Duration Display
//                         Obx(() => controller.tripDuration > 0
//                             ? Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.orange.withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.schedule,
//                                 color: Colors.orange,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Trip Duration: ${controller.tripDuration} days',
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                             : const SizedBox()),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Generate Plan Button
//                   const GeneratePlanButton(),
//                   const SizedBox(height: 24),
//
//                   // Generated Itinerary
//                   Obx(() => controller.showItinerary.value
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 4,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange,
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             const Text(
//                               'Your Itinerary',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       const ItineraryList(),
//                     ],
//                   )
//                       : const SizedBox()),
//
//                   const SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controller/trip_planner_controller.dart';
import '../widgets/destination_selector.dart';
import '../widgets/date_selector.dart';
import '../widgets/budget_selector.dart';
import '../widgets/generate_plan_button.dart';
import '../widgets/itinerary_list.dart';


class TripPlannerScreen extends StatelessWidget {
  const TripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripPlannerController());

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/onboarding1.png'),
                fit: BoxFit.cover,
                onError: null,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),

                    const SizedBox(height: 40),

                    // Title Section
                    const Text(
                      'Plan Your Journey',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Discover the land of the Pharaohs and explore ancient wonders with AI-powered planning.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Planning Form
                    _buildPlanningForm(controller, context),

                    const SizedBox(height: 32),

                    // Generate Button
                    Obx(() => _buildGenerateButton(controller)),

                    const SizedBox(height: 40),

                    // Itinerary Section
                    Obx(() => controller.showItinerary.value
                        ? _buildItinerarySection()
                        : const SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanningForm(TripPlannerController controller, BuildContext context) {
    return Column(
      children: [
        // Destination
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Where to?', Icons.location_on),
              const SizedBox(height: 12),
              Obx(() => _buildGlassDropdown(controller)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Dates
        Row(
          children: [
            Expanded(
              child: _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Start', Icons.flight_takeoff, small: true),
                    const SizedBox(height: 8),
                    Obx(() => _buildDateButton(
                      controller.selectedStartDate.value,
                          () => controller.selectStartDate(context),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('End', Icons.flight_land, small: true),
                    const SizedBox(height: 8),
                    Obx(() => _buildDateButton(
                      controller.selectedEndDate.value,
                          () => controller.selectEndDate(context),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Budget
        _buildGlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Budget Range', Icons.attach_money),
              const SizedBox(height: 12),
              Obx(() => _buildBudgetOptions(controller)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Duration Display
        Obx(() => controller.tripDuration > 0
            ? _buildGlassCard(
          color: Colors.orange.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.schedule,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${controller.tripDuration} ${controller.tripDuration == 1 ? 'Day' : 'Days'} Adventure',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
            : const SizedBox()),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text, IconData icon, {bool small = false}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: small ? 16 : 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: small ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassDropdown(TripPlannerController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedDestination.value.isEmpty
              ? null
              : controller.selectedDestination.value,
          hint: const Text(
            'Select destination',
            style: TextStyle(color: Colors.white70),
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          items: controller.destinations.map((destination) {
            return DropdownMenuItem(
              value: destination,
              child: Text(destination),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedDestination.value = value;
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateButton(DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 8),
            Text(
              date == null
                  ? 'Select'
                  : '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontSize: 13,
                color: date == null ? Colors.white60 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOptions(TripPlannerController controller) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.budgetOptions.map((budget) {
        final isSelected = controller.selectedBudget.value == budget;
        return InkWell(
          onTap: () => controller.selectedBudget.value = '$budget',
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.orange
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.orange
                    : Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              '$budget',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton(TripPlannerController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.canGeneratePlan
            ? () => controller.generateItinerary()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          disabledBackgroundColor: Colors.white.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: controller.canGeneratePlan
                  ? Colors.white
                  : Colors.white54,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              'Generate My Trip',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: controller.canGeneratePlan
                    ? Colors.white
                    : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItinerarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Itinerary',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildItineraryDay('Day 1', [
          {'icon': Icons.wb_sunny, 'time': '9:00 AM', 'activity': 'Visit Pyramids of Giza'},
          {'icon': Icons.restaurant, 'time': '1:00 PM', 'activity': 'Lunch at Nile view restaurant'},
          {'icon': Icons.museum, 'time': '3:00 PM', 'activity': 'Egyptian Museum tour'},
        ]),
        const SizedBox(height: 12),
        _buildItineraryDay('Day 2', [
          {'icon': Icons.sailing, 'time': '10:00 AM', 'activity': 'Nile River cruise'},
          {'icon': Icons.location_city, 'time': '2:00 PM', 'activity': 'Explore Khan El Khalili Bazaar'},
          {'icon': Icons.dinner_dining, 'time': '7:00 PM', 'activity': 'Traditional Egyptian dinner'},
        ]),
        const SizedBox(height: 12),
        _buildItineraryDay('Day 3', [
          {'icon': Icons.temple_buddhist, 'time': '8:00 AM', 'activity': 'Luxor Temple visit'},
          {'icon': Icons.landscape, 'time': '12:00 PM', 'activity': 'Valley of the Kings'},
          {'icon': Icons.local_airport, 'time': '6:00 PM', 'activity': 'Departure'},
        ]),
      ],
    );
  }

  Widget _buildItineraryDay(String day, List<Map<String, dynamic>> activities) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    activity['icon'] as IconData,
                    color: Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    activity['time'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity['activity'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}