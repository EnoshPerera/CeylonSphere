import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/voice_chatbot.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5631),
          primary: const Color(0xFF1E5631),
          secondary: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CeylonSphere',
          style: TextStyle(color: Color(0xFF1E5631)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E5631),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomePage()), // Changed from VoiceChatBot
            );
          },
          child: const Text(
            "Start Chatting",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
