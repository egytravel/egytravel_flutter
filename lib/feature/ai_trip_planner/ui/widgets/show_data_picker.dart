import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime? start, DateTime? end) onSave;

  const DatePickerWidget({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 500,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Dates',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Picker
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SfDateRangePicker(
                      initialDisplayDate: DateTime.now(),
                      minDate: DateTime.now(),
                      selectionMode: DateRangePickerSelectionMode.range,
                      startRangeSelectionColor: Colors.orange,
                      endRangeSelectionColor: Colors.orange,
                      rangeSelectionColor: Colors.orange.withOpacity(0.3),
                      todayHighlightColor: Colors.orange,
                      selectionColor: Colors.orange,
                      backgroundColor: Colors.transparent,
                      headerStyle: const DateRangePickerHeaderStyle(
                        backgroundColor: Colors.transparent,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Colors.transparent,
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        dayFormat: 'd',
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        todayTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        disabledDatesTextStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        weekendTextStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      yearCellStyle: const DateRangePickerYearCellStyle(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        todayTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          setState(() {
                            _startDate = args.value.startDate;
                            _endDate = args.value.endDate;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(_startDate, _endDate);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Dates',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}