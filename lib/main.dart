import 'package:flutter/material.dart';
import 'pages/firstscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF003734),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF003734),
          secondary: Colors.tealAccent,
        ),
      ),
      home: FirstScreen(),
    );  }
}
