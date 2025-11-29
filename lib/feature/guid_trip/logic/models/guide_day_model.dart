import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideDayModel {
  final int dayNumber;
  final RxString place;
  final RxString address;
  final RxString notes;
  final RxBool isExpanded;

  late final TextEditingController placeController;
  late final TextEditingController addressController;
  late final TextEditingController notesController;

  GuideDayModel({
    required this.dayNumber,
    String place = '',
    String address = '',
    String notes = '',
    bool isExpanded = true,
  })  : place = place.obs,
        address = address.obs,
        notes = notes.obs,
        isExpanded = isExpanded.obs {
    placeController = TextEditingController(text: place);
    addressController = TextEditingController(text: address);
    notesController = TextEditingController(text: notes);

    // Sync controllers with Rx variables if needed, or just use controllers directly in UI
    // For now, we update Rx variables when controller changes to keep reactivity if used elsewhere
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
