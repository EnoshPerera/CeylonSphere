import 'package:flutter/material.dart';

class SouvenirItemPage extends StatelessWidget {
  const SouvenirItemPage({super.key});

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
                // Background Image
                Image.asset(
                  'assets/bamunu_mask.jpg', // Make sure to add this image to your assets
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    );
                  },
                ),

                // Back button
                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800]?.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // AR View Button with improved visibility
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // This will be implemented by your friend for AR functionality
                        print('Navigate to AR View');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[800]?.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.view_in_ar,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'View in AR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  // Title
                  const Text(
                    '"Bamunu" Mask',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Origin indicator
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Traditional Sri Lankan Craft',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "The Bamunu Mask is a striking and culturally significant traditional mask of Sri Lanka, representing the Bamuna (Brahmin) figure—a symbol of power, wisdom, and dominance in ancient society. Used primarily in ritual performances, folk dramas, and traditional Kolam dances, this mask portrays a stern and commanding expression, reflecting the influence of Brahmins in Sri Lankan history.\n\nThe Bamunu Mask is often carved from lightweight Kaduru wood, hand-painted with bold colors, and adorned with intricate designs and exaggerated facial features, such as a high forehead, arched eyebrows, and a prominent nose—symbolizing intelligence and authority.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Craftsmanship Section
                  const Text(
                    'Traditional Craftsmanship',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '• Hand-carved from Kaduru wood',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Traditional hand-painting techniques',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Authentic Sri Lankan craftsmanship',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
