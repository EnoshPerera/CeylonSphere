import 'package:flutter/material.dart';
import 'package:ceylon_sphere/routes.dart'; // Import your routes file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CeylonSphere',
      theme: ThemeData.light(),
      initialRoute: '/profile', // Set the initial route to the profile screen
      routes: AppRoutes.routes, // Use the defined routes
    );
  }
}
