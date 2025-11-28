import 'package:get/get.dart';

class GuideDayModel {
  final int dayNumber;
  String place;
  String address;
  String notes;
  final RxBool isExpanded;

  GuideDayModel({
    required this.dayNumber,
    this.place = '',
    this.address = '',
    this.notes = '',
    bool isExpanded = true,
  }) : isExpanded = isExpanded.obs;
}
