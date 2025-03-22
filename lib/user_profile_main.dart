import 'package:ceylonsphere/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const UserProfile());
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

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
