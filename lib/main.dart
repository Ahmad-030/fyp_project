import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Splash_Screen/SplashScreen_ui.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FYP PROJECT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set your initial route
      home: SplashScreen(), // Your splash screen widget

    );
  }
}
