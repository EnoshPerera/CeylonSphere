import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shop/pages/shop_page.dart';

void main() { 
  runApp(const ShopMain());
}

class ShopMain extends StatelessWidget {
  const ShopMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Handcraft & Souvenir Shop',
      theme: ThemeData(
        primaryColor: const Color(0xFF197652),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF197652),
          primary: const Color(0xFF197652),
          secondary: const Color(0xFF02DE94),
          tertiary: const Color(0xFF003734),
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF197652)),
          titleTextStyle: TextStyle(
            color: Color(0xFF197652),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ShopPage(),
    );
  }
}
