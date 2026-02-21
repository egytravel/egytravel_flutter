import 'package:flutter/material.dart';

// This widget is no longer used as the TabBar is now in BookingScreen
// Keeping for backward compatibility
class BookingScreenBody extends StatelessWidget {
  const BookingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Booking Screen Body', style: TextStyle(color: Colors.white)),
    );
  }
}
