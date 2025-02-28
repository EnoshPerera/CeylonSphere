import 'package:flutter/material.dart';
import 'restaurants_page.dart'; // Import the restaurant page

class NearbyServicesScreen extends StatelessWidget {
  final List<Map<String, String>> services = [
    {"name": "Restaurants", "image": "assets/restaurants.jpg"},
    {"name": "Supermarket", "image": "assets/supermarket.jpg"},
    {"name": "Souvenir Shops", "image": "assets/souvenir_shops.jpg"},
    {"name": "Transport", "image": "assets/transport.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Services"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return ServiceCard(
              title: services[index]["name"]!,
              imagePath: services[index]["image"]!,
              onTap: () {
                // Navigate to the Restaurant Page if user clicks on "Restaurants"
                if (services[index]["name"] == "Restaurants") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RestaurantPage()),
                  );
                }
                // TODO: Navigate to details page
                debugPrint("${services[index]["name"]} clicked");
              },
            );
          },
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
