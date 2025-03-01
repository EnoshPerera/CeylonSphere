import 'package:flutter/material.dart';
import 'destinations_detail_page.dart';
import '../models/destination.dart';

class DestinationsListPage extends StatelessWidget {
  const DestinationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a placeholder for my teammate's implementation
    // When they complete their work, this will be replaced

    // Sample destinations data
    final destinations = [
      Destination(
        name: 'Sigiriya',
        country: 'Sri Lanka',
        imagePath: 'assets/sigiriya.jpg',
        description: "Sigiriya, the \"Lion Rock,\" is an awe-inspiring ancient fortress and UNESCO World Heritage Site in Sri Lanka. Rising 200 meters above lush greenery, it features stunning frescoes, intricate gardens, and the famous Mirror Wall. At its summit lie the ruins of a royal palace offering breathtaking views.",
      ),
      Destination(
        name: 'Ruwanwelisaya',
        country: 'Sri Lanka',
        imagePath: 'assets/ruwanwelisaya.jpg',
        description: "Ruwanwelisaya is a stupa in Sri Lanka, considered a marvel for its architectural qualities and sacred nature. Built by King Dutugemunu around 140 B.C., this iconic white dome rises 103 meters (338 ft) and is surrounded by a wall of elephant sculptures. As one of the world's tallest ancient monuments, it remains an important place of worship for Buddhists.",
      ),
      Destination(
        name: 'Galle Fort',
        country: 'Sri Lanka',
        imagePath: 'assets/galle_fort.jpg',
        description: "Galle Fort, built by the Portuguese in the 16th century and later fortified by the Dutch, is a UNESCO World Heritage site on Sri Lanka's southwest coast. This well-preserved colonial fortress features a unique blend of European architecture and South Asian traditions. Within its walls are charming streets lined with boutiques, cafes, and historic buildings.",
      ),
      Destination(
        name: 'Kandy',
        country: 'Sri Lanka',
        imagePath: 'assets/kandy.jpg',
        description: "Kandy is a scenic city in central Sri Lanka and the last capital of the ancient kings' era. Set around a picturesque lake, it's home to the Temple of the Sacred Tooth Relic (Sri Dalada Maligawa), one of Buddhism's most sacred sites. The city is known for its rich cultural heritage, traditional dance forms, and the annual Esala Perahera festival.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ceylonsphere'),
      ),
      body: ListView.builder(
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the detail page when a destination is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DestinationDetailPage(
                    destinationName: destination.name,
                    imagePath: destination.imagePath,
                    description: destination.description,
                    country: destination.country,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Destination image
                  Image.asset(
                    destination.imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      );
                    },
                  ),
                  // Destination details
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              destination.country,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}