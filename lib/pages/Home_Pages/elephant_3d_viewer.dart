import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Elephant3DViewer extends StatefulWidget {
  const Elephant3DViewer({super.key});

  @override
  State<Elephant3DViewer> createState() => _Elephant3DViewerState();
}

class _Elephant3DViewerState extends State<Elephant3DViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isCardVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSouvenirCard() {
    setState(() {
      _isCardVisible = !_isCardVisible;
      if (_isCardVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('3D Elephant Model'),
        backgroundColor: Color(0xFF003734),
        brightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFF003734),
                    child: ModelViewer(
                      src: 'assets/adiya.glb',
                      alt: 'A 3D model of a Sri Lankan elephant',
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: const Color(0xFF003734),
                      disableZoom: false,
                      autoPlay: true,
                      shadowIntensity: 1,
                      exposure: 1.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF003734),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sri Lankan Elephant',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Interact with the 3D model:',
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _InteractionItem(
                            icon: CupertinoIcons.rotate_right,
                            label: 'Rotate',
                          ),
                          _InteractionItem(
                            icon: CupertinoIcons.zoom_in,
                            label: 'Zoom',
                          ),
                          _InteractionItem(
                            icon: CupertinoIcons.hand_draw,
                            label: 'Pan',
                          ),
                          const Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: _InteractionItem(
                              icon: CupertinoIcons.shopping_cart,
                              label: 'Souvenirs',
                            ),
                            onPressed: _toggleSouvenirCard,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Souvenir pop-up card
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - _animation.value) * 400),
                    child: child,
                  );
                },
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 8,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Souvenir Shops',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003734),
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: Color(0xFF003734),
                              ),
                              onPressed: _toggleSouvenirCard,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: CupertinoColors.systemGrey5,
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: const [
                            SouvenirShopCard(
                              name: 'Pinnawala Elephant Shop',
                              address:
                                  'Pinnawala Elephant Orphanage, Rambukkana',
                              description:
                                  'Located at the famous elephant orphanage, offering handcrafted elephant souvenirs made by local artisans.',
                              distance: '2.5 km',
                              rating: 4.7,
                            ),
                            SizedBox(height: 16),
                            SouvenirShopCard(
                              name: 'Laksala Handicrafts',
                              address: 'Kandy Road, Peradeniya',
                              description:
                                  'Government-owned handicraft store with authentic Sri Lankan elephant carvings and souvenirs.',
                              distance: '3.8 km',
                              rating: 4.3,
                            ),
                            SizedBox(height: 16),
                            SouvenirShopCard(
                              name: 'Colombo Craft House',
                              address: 'Liberty Plaza, Colombo 03',
                              description:
                                  'Premium handmade elephant models and souvenirs with a modern twist on traditional designs.',
                              distance: '12.1 km',
                              rating: 4.8,
                            ),
                            SizedBox(height: 16),
                            SouvenirShopCard(
                              name: 'Elephant Transit Home Gift Shop',
                              address: 'Udawalawe National Park',
                              description:
                                  'All proceeds go to elephant conservation efforts. Features unique elephant figurines and educational toys.',
                              distance: '45.3 km',
                              rating: 4.5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InteractionItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: CupertinoColors.white,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class SouvenirShopCard extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String distance;
  final double rating;

  const SouvenirShopCard({
    super.key,
    required this.name,
    required this.address,
    required this.description,
    required this.distance,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003734),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF003734),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.star_fill,
                      color: CupertinoColors.systemYellow,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.location,
                    color: CupertinoColors.systemGrey,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    distance,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
              CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF003734),
                borderRadius: BorderRadius.circular(20),
                minSize: 0,
                child: const Text('Directions'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
