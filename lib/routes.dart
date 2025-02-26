import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/privacy_policy_screen.dart';  // Import PrivacyPolicyScreen
import 'screens/terms_and_conditions_screen.dart';  // Import TermsAndConditionsScreen

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/profile': (context) => ProfileScreen(),
    '/edit-profile': (context) => EditProfileScreen(),
    '/privacy-policy': (context) => PrivacyPolicyScreen(), // Add route for PrivacyPolicyScreen
    '/terms-and-conditions': (context) => TermsAndConditionsScreen(), // Add route for TermsAndConditionsScreen
  };
}
