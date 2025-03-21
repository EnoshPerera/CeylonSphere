import 'package:flutter/material.dart';
import 'package:user_profile_page/routes.dart'; // Import your routes file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UserProfile',
      theme: ThemeData.light(),
      initialRoute: '/profile', // Set the initial route to the profile screen
      routes: AppRoutes.routes, // Use the defined routes
    );
  }
}
