import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        centerTitle: true,
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Icon
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.privacy_tip_outlined,
                      size: 60,
                      color: const Color(0xFF059669), // Updated color
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Introduction Section
              const Text(
                "Your privacy is important to us. This policy explains how we collect, use, and protect your information.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Section 1: Data Collection
              _buildSection(
                context,
                icon: Icons.data_usage,
                title: "Data Collection",
                content:
                    "We collect information such as your name, email address, and usage data to provide and improve our services.",
              ),
              const SizedBox(height: 16),

              // Section 2: Data Usage
              _buildSection(
                context,
                icon: Icons.analytics_outlined,
                title: "Data Usage",
                content:
                    "Your data is used to personalize your experience, improve our app, and communicate with you.",
              ),
              const SizedBox(height: 16),

              // Section 3: Data Sharing
              _buildSection(
                context,
                icon: Icons.share_outlined,
                title: "Data Sharing",
                content:
                    "We do not share your personal data with third parties except as required by law or to provide our services.",
              ),
              const SizedBox(height: 16),

              // Section 4: Data Security
              _buildSection(
                context,
                icon: Icons.security_outlined,
                title: "Data Security",
                content:
                    "We implement industry-standard security measures to protect your data from unauthorized access.",
              ),
              const SizedBox(height: 24),

              // Footer Note
              Padding(
                padding: const EdgeInsets.only(bottom: 100), // Add bottom padding
                child: Center(
                  child: Text(
                    "If you have any questions about our privacy policy, please contact us at ceylonsphere@gmail.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 158, 158, 158),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a section with icon, title, and content
  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF059669), // Updated color
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}