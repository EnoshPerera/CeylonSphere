import 'package:flutter/material.dart';
import 'registration_page.dart'; // Import the RegistrationPage
import 'login_page.dart'; // Import the LoginPage

class WelcomePopup {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows tapping outside to close the popup
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF004D49), // Dark popup background
          title: const Center(
            child: Text(
              "Welcome",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          content: const Text(
            "Discover the beauty and adventure of Sri Lanka. Your journey starts here!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginPage()), // Navigate to LoginPage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003734), // Button color
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegistrationPage()), // Navigate to RegistrationPage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF003734), // Same as Log in button
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        );
      },
    );
  }
}
