import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
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
                      Icons.description_outlined,
                      size: 60,
                      color: const Color(0xFF059669), // Updated color
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Terms and Conditions",
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
                "Please read these terms and conditions carefully before using our services. By using our services, you agree to these terms.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Section 1: User Responsibilities
              _buildSection(
                context,
                icon: Icons.assignment_outlined,
                title: "User Responsibilities",
                content:
                    "You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.",
              ),
              const SizedBox(height: 16),

              // Section 2: Prohibited Activities
              _buildSection(
                context,
                icon: Icons.block_outlined,
                title: "Prohibited Activities",
                content:
                    "You agree not to engage in any activity that interferes with or disrupts the services or the servers and networks connected to the services.",
              ),
              const SizedBox(height: 16),

              // Section 3: Limitation of Liability
              _buildSection(
                context,
                icon: Icons.warning_outlined,
                title: "Limitation of Liability",
                content:
                    "We shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or use.",
              ),
              const SizedBox(height: 16),

              // Section 4: Changes to Terms
              _buildSection(
                context,
                icon: Icons.update_outlined,
                title: "Changes to Terms",
                content:
                    "We reserve the right to modify or replace these terms at any time. Your continued use of the services after any changes constitutes your acceptance of the new terms.",
              ),
              const SizedBox(height: 24),

              // Footer Note
              Padding(
                padding: const EdgeInsets.only(bottom: 100), // Add bottom padding
                child: Center(
                  child: Text(
                    "If you have any questions about our terms and conditions, please contact us at ceylonsphere@gmail.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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