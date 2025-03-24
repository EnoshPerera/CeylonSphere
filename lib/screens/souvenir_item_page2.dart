import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class SouvenirItemPage extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;
  final String? modelPath;

  const SouvenirItemPage({
    super.key,
    required this.title,
    required this.content,
    required this.imagePath,
    this.modelPath,
  });

  static List<Souvenir> getSouvenirs() {
    return [
      Souvenir(
        name: 'Bathik Sarong for Women',
        imagePath: 'assets/bathik_sarong_for_women.webp',
        modelPath: 'assets/bathik_sarong_for_women1.glb',
        description:
        "The Batik Sarong for Women is a beautifully handcrafted garment that showcases Sri Lanka's rich artistic heritage. Made from high-quality cotton or silk, each sarong is dyed using the traditional batik technique, creating intricate patterns and vibrant colors. Comfortable and versatile, it can be worn casually or for special occasions, making it a perfect blend of tradition and modern fashion. Available in various designs and sizes, the price varies based on fabric and craftsmanship. Whether for daily wear, beach outings, or cultural events, a batik sarong adds elegance and uniqueness to any wardrobe.",
        rating: 4.6,
        categories: ['Casual Wear', 'Cultural Events', 'Beach Outings'],
      ),
      Souvenir(
        name: 'Bathik Shirt And Sarong',
        imagePath: 'assets/bathik_shirt_and_sarong.webp',
        modelPath: 'assets/bathik_shirt_and_sarong1.glb',
        description:
        "The Batik Shirt and Sarong set is a beautifully handcrafted outfit that reflects Sri Lanka's rich artistic and cultural heritage. Made from premium cotton or silk, each piece is hand-dyed using the traditional batik technique, creating intricate patterns and vibrant colors. This stylish and comfortable ensemble is perfect for casual outings, cultural events, beachwear, or festive occasions. With a blend of tradition and modern fashion, the batik shirt and sarong offer a unique and elegant look for any occasion. Available in various sizes and designs, the price varies based on fabric quality and craftsmanship.",
        rating: 4.7,
        categories: ['Ideal for Casual Wear', 'Cultural Events', 'Special Occasions'],
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Collapsing App Bar with 3D Model or Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 3D Model or Image based on availability
                    if (modelPath != null)
                      _build3DModelViewer()
                    else
                      Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    // Gradient Overlay (only for image)
                    if (modelPath == null)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.back, color: Colors.green),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(CupertinoIcons.location_solid,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        'Traditional Sri Lankan Craft',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Rating Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Categories
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildCategory('Traditional Art'),
                            _buildCategory('Cultural'),
                            _buildCategory('Handcrafted'),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Description Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // About Section Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                CupertinoIcons.info,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // About Content Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            content,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Craftsmanship Section Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                CupertinoIcons.hammer,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Craftsmanship',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Craftsmanship Content
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildCraftDetail(
                                icon: CupertinoIcons.paintbrush_fill,
                                title: 'Hand-dyed on premium cotton or silk',
                              ),
                              const SizedBox(height: 12),
                              _buildCraftDetail(
                                icon: CupertinoIcons.color_filter,
                                title: 'Traditional and contemporary batik patterns with vibrant colors',
                              ),
                              const SizedBox(height: 12),
                              _buildCraftDetail(
                                icon: CupertinoIcons.checkmark_seal_fill,
                                title: 'Varies based on fabric quality and craftsmanship',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3D model viewer for GLB files
  Widget _build3DModelViewer() {
    return SizedBox(
      height: 300,
      child: ModelViewer(
        src: modelPath!,
        alt: "A 3D model of $title",
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
        ar: false, // Disable AR
        arModes: const [], // No AR modes
        autoPlay: true,
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        // Disable all AR-related feature
        disableTap: false,
        disablePan: false,
      ),
    );
  }

  Widget _buildCategory(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCraftDetail({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class Souvenir {
  final String name;
  final String imagePath;
  final String? modelPath; // Path to 3D model
  final String description;
  final double rating;
  final List<String> categories;

  Souvenir({
    required this.name,
    required this.imagePath,
    this.modelPath, // Optional 3D model path
    required this.description,
    required this.rating,
    required this.categories,
  });
}

