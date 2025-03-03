import 'package:flutter/material.dart';
import 'destinations_detail_page.dart';

class DestinationsListPage extends StatelessWidget {
  const DestinationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a placeholder for my teammate's implementation
    // When they complete their work, this will be replaced

    // Get destinations data from the DestinationsData class
    final destinations = DestinationsData.getDestinations();

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
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
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
