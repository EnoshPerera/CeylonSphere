import 'package:ceylonsphere/screens/voice_chatbot.dart';
import 'package:flutter/material.dart';
import 'package:your_app_name/app/theme/app_theme.dart';
import 'package:your_app_name/screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CeylonSphere',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // ✅ Start from Home Screen
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CeylonSphere")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ✅ Navigate to the chatbot screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VoiceChatbot()),
            );
          },
          child: Text("Go to Voice Chatbot"),
        ),
      ),
    );
  }
}
