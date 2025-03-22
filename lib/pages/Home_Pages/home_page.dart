import 'package:ceylonsphere/Nearby_Services_Pages/nearby_services_main.dart';
import 'package:ceylonsphere/User_Profile_Page/profile_screen.dart';
import 'package:ceylonsphere/user_profile_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import '../Profile_Pages/profile_screen.dart';
import 'destinations_screen.dart';
import '../../explore_activities/explore_activities_screen.dart';
import 'destination_profile.dart';
import '../../destinationCarousel_widget/destination_carousel.dart';
import 'ar_temple_screen.dart';
import '../Transport_Pages/transport.dart';
import '../../chatbot/travel_chatbot_screen.dart';
import 'adventure_deals.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'CeylonSphere',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.activeGreen,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map), label: 'Destinations'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.car), label: 'Transport'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person), label: 'Profile'),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeScreen();
          case 1:
            return const DestinationsScreen();
          case 2:
            return TransportScreen();
          case 3:
            return const UserProfile();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('CeylonSphere'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Center(
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(15),
              //       child: Image.asset(
              //         'assets/vr_tourism.png',
              //         height: 130,
              //         width: 650,
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quick Access',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003734),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Show all categories
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) => Container(
                                  height: 500,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: CupertinoColors.systemBackground,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'All Categories',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF003734),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20,
                                          children: [
                                            _CategoryGridItem(
                                              icon: CupertinoIcons.map,
                                              label: 'Places',
                                              onTap: () {
                                                Navigator.pop(
                                                    context); // Close the modal first
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        NearbyServices(),
                                                  ),
                                                );
                                              },
                                            ),
                                            const _CategoryGridItem(
                                              icon:
                                                  CupertinoIcons.chat_bubble_2,
                                              label: 'Chatbot',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.news,
                                              label: 'Restaurants',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.bag,
                                              label: 'Shopping',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.tickets,
                                              label: 'Events',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.car_detailed,
                                              label: 'Transport',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.camera,
                                              label: 'Photography',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.gift,
                                              label: 'Souvenirs',
                                            ),
                                            const _CategoryGridItem(
                                              icon: CupertinoIcons.cart,
                                              label: 'Markets',
                                            ),
                                            const _CategoryGridItem(
                                              icon:
                                                  CupertinoIcons.chat_bubble_2,
                                              label: 'Travel Assistant',
                                              // onTap: () {
                                              //   Navigator.pop(
                                              //       context); // Close modal before navigating
                                              //   // Navigator.push(
                                              //   //   context,
                                              //   //   CupertinoPageRoute(
                                              //   //     builder: (context) =>
                                              //   //         const TravelChatbotScreen(),
                                              //   //   ),
                                              //   // );
                                              // },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: CupertinoColors.activeGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  CupertinoIcons.chevron_right,
                                  color: CupertinoColors.activeGreen,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          _CategoryItem(
                            icon: CupertinoIcons.map,
                            label: 'Places',
                            color: const Color(0xFF4CAF50),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => NearbyServices(),
                                ),
                              );
                            },
                          ),
                          const _CategoryItem(
                            icon: CupertinoIcons.chat_bubble_2, // Chatbot icon
                            label: 'Chatbot',
                            color: Color(0xFF2196F3), // Keeping the same color
                          ),
                          const _CategoryItem(
                            icon: CupertinoIcons.news,
                            label: 'Restaurants',
                            color: Color(0xFFF44336),
                          ),
                          const _CategoryItem(
                            icon: CupertinoIcons.bag,
                            label: 'Shopping',
                            color: Color(0xFF9C27B0),
                          ),
                          const _CategoryItem(
                            icon: CupertinoIcons.tickets,
                            label: 'Events',
                            color: Color(0xFFFF9800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Replace the existing ListView with the DestinationCarousel
              const DestinationCarousel(),

              PromoBanner(
                title: 'Explore Activities',
                subtitle: 'Discover top adventure & cultural tours',
                color: Color(0xFF003734),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ExploreActivitiesScreen()),
                  );
                },
              ),

              PromoBanner(
                title: 'Adventure Deal',
                subtitle: '30% OFF',
                color: Colors.orangeAccent,
                onTap: () {
                  // Navigate to AdventureDealsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdventureDealsPage()),
                  );
                },
              ),

              //Promo Banner
              PromoBanner(
                title: 'AR Experience',
                subtitle: 'Explore temples in Augmented Reality',
                color: const Color.fromARGB(
                    255, 0, 102, 255), // Deep purple for tech feel
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   CupertinoPageRoute(
                  //     builder: (context) => ARTempleScreen(),
                  //   ),
                  // );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore Now',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                CupertinoIcons.arrow_right,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _CategoryGridItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF003734).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF003734),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF003734),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Keep your existing DestinationCard class for other parts of the app
class DestinationCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String location;
  final int initialLikes;

  const DestinationCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.initialLikes,
  }) : super(key: key);

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  late int likes;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    likes = widget.initialLikes;
    isLiked = false;
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likes--;
      } else {
        likes++;
      }
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red[300],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text('$likes'),
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
}
