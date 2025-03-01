import 'package:flutter/material.dart';
import 'screens/destinations_list_page.dart';
import 'screens/destinations_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ceylonsphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Start with the destinations list page
      home: const DestinationsListPage(),
    );
  }
}