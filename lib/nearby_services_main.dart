import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Nearby_Services_Pages/screens/nearby_services_screen.dart';
import 'Nearby_Services_Pages/constants/api_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request location permissions at startup
  await Geolocator.requestPermission();
  
  // Initialize Google Maps
  await GoogleMapServices.init();
  
  runApp(const MyApp());
}

class GoogleMapServices {
  static Future<void> init() async {
    // Add any Google Maps initialization here if needed in the future
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CeylonSphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
      ),
      home: const NearbyServicesScreen(),
    );
  }
}
