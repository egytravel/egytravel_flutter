import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideDayModel {
  final String? id;
  final int dayNumber;
  final RxString place;
  final RxString address;
  final RxString notes;
  final RxBool isExpanded;
  final RxList<TripBookingModel> bookings;

  late final TextEditingController placeController;
  late final TextEditingController addressController;
  late final TextEditingController notesController;

  GuideDayModel({
    this.id,
    required this.dayNumber,
    String place = '',
    String address = '',
    String notes = '',
    bool isExpanded = true,
    List<TripBookingModel> bookings = const [],
  })  : place = place.obs,
        address = address.obs,
        notes = notes.obs,
        isExpanded = isExpanded.obs,
        bookings = bookings.obs {
    placeController = TextEditingController(text: place);
    addressController = TextEditingController(text: address);
    notesController = TextEditingController(text: notes);

    // Sync controllers with Rx variables
    placeController.addListener(() => this.place.value = placeController.text);
    addressController.addListener(() => this.address.value = addressController.text);
    notesController.addListener(() => this.notes.value = notesController.text);
  }

  void dispose() {
    placeController.dispose();
    addressController.dispose();
    notesController.dispose();
  }
}
