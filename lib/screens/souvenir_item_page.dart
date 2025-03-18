import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class SouvenirItemPage extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath;
  final String? modelPath; // Path to the 3D model file (.glb)

  const SouvenirItemPage({
    super.key,
    required this.title,
    required this.content,
    required this.imagePath,
    this.modelPath, // Optional for backward compatibility
  });

  static List<Souvenir> getSouvenirs() {
    return [
      Souvenir(
        name: 'Bamunu Mask',
        imagePath: 'assets/bamunu_mask.jpg',
        modelPath: 'assets/bamunu_mask_01.glb',
        description:
        "The Bamunu Mask is a striking and culturally significant traditional mask of Sri Lanka, representing the Bamuna (Brahmin) figure—a symbol of power, wisdom, and dominance in ancient society. Used primarily in ritual performances, folk dramas, and traditional Kolam dances, this mask portrays a stern and commanding expression, reflecting the influence of Brahmins in Sri Lankan history.",
        rating: 4.8,
        categories: ['Traditional Art', 'Cultural', 'Handcrafted'],
      ),
      Souvenir(
        name: 'Naga Rassa Mask',
        imagePath: 'assets/naga_rassa_mask.jpg',
        modelPath: 'assets/naga_rassa_mask_01.glb',
        description:
        "The Naga Rassa Mask is a unique and mystical mask in Sri Lankan traditional folklore, representing the serpent spirit (Naga). In ancient beliefs, the Naga (divine serpent) is associated with protection, power, and water deities, often linked to rainfall, fertility, and prosperity. The mask is prominently used in ritual performances and masked dances, invoking the spiritual energy of the serpent to ward off evil and bring blessings.\n\nThe design of the Naga Rassa Mask is striking, often featuring multiple snake heads, wide eyes, and intricate patterns symbolizing the mystical and divine power of the Naga. Painted in bold colors like red, green, and gold, it captures the ferocity and grace of the serpent deity.",
        rating: 4.7,
        categories: ['Mythical', 'Cultural', 'Handcrafted'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: const Icon(CupertinoIcons.back, color: Colors.white),
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

                      const SizedBox(height: 24),
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
                              title: 'Hand-carved from Kaduru wood',
                            ),
                            const SizedBox(height: 12),
                            _buildCraftDetail(
                              icon: CupertinoIcons.color_filter,
                              title: 'Traditional hand-painting techniques',
                            ),
                            const SizedBox(height: 12),
                            _buildCraftDetail(
                              icon: CupertinoIcons.checkmark_seal_fill,
                              title: 'Authentic Sri Lankan craftsmanship',
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
        ],
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

