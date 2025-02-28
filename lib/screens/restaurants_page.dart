import 'package:flutter/material.dart';
import 'restaurant_details_page.dart'; // Step 3 - Restaurant Details Page

class RestaurantPage extends StatelessWidget {
  final List<Map<String, String>> restaurants = [
    {
      "name": "Golden Dragon",
      "image": "assets/golden_dragon.jpg",
      "location": "Colombo 07, Sri Lanka",
    },
    {
      "name": "The Lagoon",
      "image": "assets/the_lagoon.jpg",
      "location": "Galle Face, Colombo",
    },
    {
      "name": "Ministry of Crab",
      "image": "assets/ministry_of_crab.jpg",
      "location": "Dutch Hospital, Colombo",
    },
    {
      "name": "The Barnhouse",
      "image": "assets/the_barnhouse.jpg",
      "location": "Panadura, Sri Lanka",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return RestaurantCard(
            name: restaurants[index]["name"]!,
            image: restaurants[index]["image"]!,
            location: restaurants[index]["location"]!,
            onTap: () {
              // Navigate to Restaurant Details Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailsPage(
                    name: restaurants[index]["name"]!,
                    image: restaurants[index]["image"]!,
                    location: restaurants[index]["location"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final VoidCallback onTap;

  const RestaurantCard({
    required this.name,
    required this.image,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
