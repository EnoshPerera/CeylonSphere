import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E5631),
        primary: const Color(0xFF1E5631),
        secondary: const Color(0xFF2E7D32),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F7F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1E5631),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}