import 'package:egytravel_app/feature/ai_trip_planner/data/repo/ai_trip_repo.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime time;

  Message({required this.text, required this.isUser, required this.time});
}

class ChatController extends GetxController {
  final AiTripRepository _repository;
  ChatController(this._repository);

  final TextEditingController messageController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // Welcome message
    messages.add(Message(
      text: "Hello! I am your EgyTravel AI assistant. How can I help you with your trip today?",
      isUser: false,
      time: DateTime.now(),
    ));
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    messages.add(Message(text: text, isUser: true, time: DateTime.now()));
    _scrollToBottom();

    isLoading.value = true;
    try {
      double lat = 0.0;
      double lon = 0.0;

      // Try to get user's live location
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          
          if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              timeLimit: const Duration(seconds: 5),
            );
            lat = position.latitude;
            lon = position.longitude;
          }
        }
      } catch (e) {
        print("Error getting live location: $e");
        // Fallback to Trip location if live location fails or denied
        try {
          final tripController = Get.find<TripController>();
          final trip = tripController.state;
          if (trip?.data.hotel != null) {
            lat = trip!.data.hotel!.lat;
            lon = trip.data.hotel!.lon;
          }
        } catch (innerE) {
          print("Fallback to trip location also failed: $innerE");
        }
      }

      final response = await _repository.chatWithAi(text, lat, lon);
      messages.add(Message(text: response, isUser: false, time: DateTime.now()));
    } catch (e) {
      messages.add(Message(
        text: "Sorry, I encountered an error: ${e.toString()}",
        isUser: false,
        time: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
