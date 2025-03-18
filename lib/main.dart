import 'package:flutter/material.dart';
import 'pages/shop_page.dart';

// This is just an example of how to integrate the shop page
// You mentioned you already have main.dart, so this is just for reference
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handcraft & Souvenir Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ShopPage(),
    );
  }
}
