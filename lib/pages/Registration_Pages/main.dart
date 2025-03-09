import 'package:flutter/material.dart';
import 'firstscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CeylonSphere',
      theme: ThemeData(
        primaryColor: const Color(0xFF004D40),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004D40),
          primary: const Color(0xFF004D40),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

