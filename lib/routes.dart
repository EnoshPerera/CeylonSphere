import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'package:user_profile_page/screens/privacy_policy_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/profile': (context) => ProfileScreen(),
    '/edit-profile': (context) => EditProfileScreen(),
    '/privacy-policy': (context) => PrivacyPolicyScreen(), // Add route for PrivacyPolicyScreen
  };
}
