import 'package:ceylonsphere/splash_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = "English";
  bool _isNotificationEnabled = true;
  bool _isLoading = true;

  // User profile data
  String _username = "";
  String _location = "";
  String? _profileImageUrl;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _fetchUserProfile();
  }

  Future<void> _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? "English";
      _isNotificationEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);

    // Also save to Firebase if user is authenticated
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('user_preferences').doc(user.uid).set({
          'notifications_enabled': value,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving notification preference to Firebase: $e');
    }

    setState(() {
      _isNotificationEnabled = value;
    });
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Fetch user profile from Firestore
        final userData =
            await _firestore.collection('users').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _username = userData.data()?['username'] ?? "User";
            _profileImageUrl = userData.data()?['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigate to the OnboardingScreen and set the page to the last one
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OnboardingScreen(initialPage: 2), // Navigate to the last page
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    ).then((_) =>
                        _fetchUserProfile()); // Refresh profile after editing
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : const AssetImage('assets/profile_picture.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _location,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
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
                buildProfileOption("Language", Icons.language,
                    subtitle: _selectedLanguage, onTap: () {
                  showLanguageSelection(context);
                }),
                buildProfileOption("Your Trips", Icons.travel_explore),
                buildProfileOption("Privacy Policy", Icons.privacy_tip,
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()),
                  );
                }),
                buildProfileOption("Terms and Conditions", Icons.description,
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsScreen()),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _signOut,
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.white), // Changed text color to white
                    ),
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
        activeColor: const Color(0xFF059669),
      ),
    );
  }

  Widget buildProfileOption(String title, IconData icon,
      {String? subtitle, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
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

                        // Also save language preference to Firebase
                        try {
                          final user = _auth.currentUser;
                          if (user != null) {
                            _firestore
                                .collection('user_preferences')
                                .doc(user.uid)
                                .set({
                              'language': languages[index],
                            }, SetOptions(merge: true));
                          }
                        } catch (e) {
                          print(
                              'Error saving language preference to Firebase: $e');
                        }

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
