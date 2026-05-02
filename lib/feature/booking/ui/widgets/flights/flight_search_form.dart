import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/booking/data/models/flight_location_model.dart';
import 'package:egytravel_app/feature/booking/logic/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class FlightSearchForm extends StatelessWidget {
  const FlightSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Flights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // From & To
                Row(
                  children: [
                    Expanded(
                      child: _buildAutocompleteField(
                        label: 'From',
                        icon: Icons.flight_takeoff,
                        controller: controller,
                        isOrigin: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAutocompleteField(
                        label: 'To',
                        icon: Icons.flight_land,
                        controller: controller,
                        isOrigin: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Departure',
                        icon: Icons.calendar_today,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColor.primaryColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            controller.flightDepartureDate.value = date;
                          }
                        },
                        controller: controller,
                        dateValue: controller.flightDepartureDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateField(
                        label: 'Return (Optional)',
                        icon: Icons.calendar_today,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                controller.flightDepartureDate.value?.add(
                                      const Duration(days: 1),
                                    ) ??
                                    DateTime.now().add(const Duration(days: 2)),
                            firstDate: controller.flightDepartureDate.value ??
                                DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColor.primaryColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            controller.flightReturnDate.value = date;
                          }
                        },
                        controller: controller,
                        dateValue: controller.flightReturnDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Travelers & Class
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdown(
                          label: 'Travelers',
                          icon: Icons.person,
                          value: controller.flightTravelers.value.toString(),
                          items: List.generate(
                            9,
                            (index) => (index + 1).toString(),
                          ),
                          onChanged: (value) {
                            controller.flightTravelers.value = int.parse(
                              value!,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => _buildDropdown(
                          label: 'Class',
                          icon: Icons.airline_seat_recline_extra,
                          value: controller.flightClass.value,
                          items: const ['Economy', 'Business'],
                          onChanged: (value) {
                            controller.flightClass.value = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => controller.searchFlights(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Search Flights',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildAutocompleteField({
    required String label,
    required IconData icon,
    required BookingController controller,
    required bool isOrigin,
  }) {
    final initialValue = isOrigin
        ? controller.selectedFlightFrom.value?.city ?? controller.flightFrom.value
        : controller.selectedFlightTo.value?.city ?? controller.flightTo.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<FlightLocationModel>(
          initialValue: TextEditingValue(text: initialValue),
          displayStringForOption: (option) => '${option.city} (${option.code})',
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<FlightLocationModel>.empty();
            }
            return controller.flightLocations
                .where((FlightLocationModel option) {
              return option.city
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()) ||
                  option.code
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (FlightLocationModel selection) {
            if (isOrigin) {
              controller.selectedFlightFrom.value = selection;
              controller.flightFrom.value = selection.city;
            } else {
              controller.selectedFlightTo.value = selection;
              controller.flightTo.value = selection.city;
            }
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (value) {
                if (isOrigin) {
                  controller.flightFrom.value = value;
                  if (value.isEmpty) controller.selectedFlightFrom.value = null;
                } else {
                  controller.flightTo.value = value;
                  if (value.isEmpty) controller.selectedFlightTo.value = null;
                }
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: AppColor.primaryColor, size: 20),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 48) / 2,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option.city,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text('${option.name} (${option.code})',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10)),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required BookingController controller,
    required Rx<DateTime?> dateValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppColor.primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dateValue.value != null
                          ? '${dateValue.value!.day}/${dateValue.value!.month}/${dateValue.value!.year}'
                          : 'Select date',
                      style: TextStyle(
                        color: dateValue.value != null
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColor.primaryColor,
              ),
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: AppColor.primaryColor, size: 20),
                      const SizedBox(width: 12),
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
