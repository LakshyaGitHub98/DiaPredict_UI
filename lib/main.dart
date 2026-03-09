import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DiaPredictApp());
}

class DiaPredictApp extends StatelessWidget {
  const DiaPredictApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DiaPredict",
      home: const SplashScreen(),
    );
  }
}