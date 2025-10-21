import 'package:egytravel_app/core/routes/app_pages.dart';
import 'package:egytravel_app/feature/splash/ui/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EgyTravel',
     theme:  ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4E6C3), // soft beige background
        primaryColor: const Color(0xFFD97B29), // warm orange accent
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2C2C2C), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFF3A3A3A)),
        ),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.appPages(),
    );
  }
}
