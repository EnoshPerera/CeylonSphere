import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ceylonsphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DestinationDetailPage(
        destinationName: 'Sigiriya',
        imagePath: 'assets/sigiriya.jpg', // Local image path
      ),
    );
  }
}

class DestinationDetailPage extends StatefulWidget {
  final String destinationName;
  final String imagePath;

  const DestinationDetailPage({
    Key? key,
    required this.destinationName,
    required this.imagePath,
  }) : super(key: key);

  @override
  _DestinationDetailPageState createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  // This would eventually come from your teammate's implementation
  bool isCrowded = false;

  final String description = """
    Sigiriya, the "Lion Rock," is an awe-inspiring ancient fortress and UNESCO World Heritage Site in Sri Lanka. Rising 200 meters above lush greenery, it features stunning frescoes, intricate gardens, and the famous Mirror Wall. At its summit lie the ruins of a royal palace offering breathtaking views.
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Section with buttons
            Stack(
              children: [
                // Background Image - using local asset
                Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  // Add a placeholder in case image fails to load
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    );
                  },
                ),

                // Top title and crowded button
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.destinationName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Crowded button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.groups,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Crowded',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action buttons - now placed at the bottom of the image with spacing
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircularButton(
                        icon: Icons.play_arrow,
                        onTap: () {
                          // Navigate to AR view
                          print('Navigate to AR View');
                        },
                      ),
                      _buildCircularButton(
                        icon: Icons.volume_up,
                        onTap: () {
                          // Navigate to audio guide
                          print('Navigate to Audio Guide');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location name and country
                  Row(
                    children: [
                      Text(
                        widget.destinationName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Space reserved for crowd indicator
                      Container(
                        width: 24,
                        height: 24,
                        // This will be replaced by your friend's implementation
                      ),
                    ],
                  ),

                  const Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Sri Lanka',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(description),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}