import 'package:egytravel_app/core/routes/app_pages.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/home/ui/screen/home_screen.dart';
import 'package:egytravel_app/feature/splash/ui/screen/splash_screen.dart';
import 'package:egytravel_app/feature/trip_planner/ui/screen/trip_planner_screen.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primaryColor,
          primary: AppColor.primaryColor,
        ),
        useMaterial3: true,
      ),

      home: HomeScreen(),
     //  initialRoute: AppPages.initial,
     //  getPages: AppPages.appPages(),

    );
  }
}
