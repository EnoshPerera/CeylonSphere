import 'package:flutter/material.dart';
import 'google_maps_page.dart'; // Step 2: Import Google Maps Page

class RestaurantDetailsPage extends StatelessWidget {
  final String name;
  final String image;
  final String location;

  const RestaurantDetailsPage({
    required this.name,
    required this.image,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          // Display Restaurant Image
          Image.asset(image, width: double.infinity, height: 200, fit: BoxFit.cover),

          // Restaurant Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(location, style: const TextStyle(fontSize: 16, color: Colors.grey)),

                // View on Map Button
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Pass sample lat/lng values (modify for real locations)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMapsPage(
                          lat: 6.9271, // Example: Colombo latitude
                          lng: 79.8612, // Example: Colombo longitude
                          name: name,
                        ),
                      ),
                    );
                  },
                  child: const Text("View on Map"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
