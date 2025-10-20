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

      initialRoute: AppPages.initial,
      getPages: AppPages.appPages(),
    );
  }
}
