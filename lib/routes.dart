import 'package:flutter/material.dart';
import 'User_Profile_Page/profile_screen.dart';
import 'User_Profile_Page/edit_profile_screen.dart';
import 'User_Profile_Page/privacy_policy_screen.dart';  // Import PrivacyPolicyScreen
import 'User_Profile_Page/terms_and_conditions_screen.dart';  // Import TermsAndConditionsScreen

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/profile': (context) => ProfileScreen(),
    '/edit-profile': (context) => EditProfileScreen(),
    '/privacy-policy': (context) => PrivacyPolicyScreen(), // Add route for PrivacyPolicyScreen
    '/terms-and-conditions': (context) => TermsAndConditionsScreen(), // Add route for TermsAndConditionsScreen
  };
}
