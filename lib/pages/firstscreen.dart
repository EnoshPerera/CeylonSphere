import 'dart:ui'; // Import for blur effect
import 'package:flutter/material.dart';
import 'popup_page.dart'; // Import the popup class

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen Background Image with Blur
          Positioned.fill(
            child: Image.asset(
              'assets/firstscreen.jpg', // Ensure this image is in your assets folder
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2), // Adjust blur intensity
              child: Container(
                color: Colors.black.withOpacity(0.2), // Optional: Dark overlay for better contrast
              ),
            ),
          ),
          // Centered Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(), // Push content to the middle
                Image.asset(
                  'assets/logo-14.png', // Replace with your app logo
                  height: 150
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to CeylonSphere",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(), // Push button to the bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 50), // Add bottom spacing
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        WelcomePopup.show(context); // Show popup directly
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF00796B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
