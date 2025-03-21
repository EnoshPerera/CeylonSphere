import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart'; // Keep this import for navigation to the EditProfileScreen
import 'privacy_policy_screen.dart'; //import the new privacy policy screen
import 'terms_and_conditions_screen.dart'; //import the new TermsAndConditionsScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = "English"; // Default language
  bool _isNotificationEnabled = true; // Default notification state

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage(); // Load the stored language when the screen is initialized
    _loadNotificationPreference(); // Load notification preference
  }

  // Load selected language from SharedPreferences
  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? "English";
    });
  }

  // Save selected language to SharedPreferences
  Future<void> _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
    setState(() {
      _selectedLanguage = language; // Update UI
    });
  }

  // Load notification preference from SharedPreferences
  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  // Save notification preference to SharedPreferences
  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _isNotificationEnabled = value; // Update UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF059669), // Updated to your color code
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_picture.png'),
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Chamindu Vimeth",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Delkanda, Sri Lanka",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          buildNotificationOption(),
          buildProfileOption("Language", Icons.language, subtitle: _selectedLanguage, onTap: () {
            showLanguageSelection(context);
          }),
          buildProfileOption("Payment Methods", Icons.payment),
          buildProfileOption("Currency", Icons.attach_money),
          buildProfileOption("Privacy Policy", Icons.privacy_tip, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
            );
          }),
          buildProfileOption("Terms and Conditions", Icons.description, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text("Sign Out"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationOption() {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text("Notifications"),
      trailing: Switch(
        value: _isNotificationEnabled,
        onChanged: (bool value) {
          _saveNotificationPreference(value);
        },
        activeColor: const Color(0xFF059669), // Custom color for active state
      ),
    );
  }

  Widget buildProfileOption(String title, IconData icon, {String? subtitle, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null, // Show selected language
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  void showLanguageSelection(BuildContext context) {
    List<String> languages = ["English", "Sinhala", "Tamil"];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            children: [
              const Text(
                "Select Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(languages[index]),
                      onTap: () {
                        _saveSelectedLanguage(languages[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}