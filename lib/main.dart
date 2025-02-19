import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/profile_screen.dart';
import '/destinations_screen.dart';
import '/explore_activities_screen.dart'; // Import Explore Activities screen

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
        primaryColor: CupertinoColors.activeBlue,
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
            return const ProfileScreen();
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/vr_tourism.png',
                      height: 130,
                      width: 650,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Travel Destinations',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(5.0),
                  children: const [
                    DestinationImage(imagePath: 'assets/Kandy.jpg'),
                    DestinationImage(imagePath: 'assets/Yala.jpg'),
                    DestinationImage(imagePath: 'assets/Kandy.jpg'),
                    DestinationImage(imagePath: 'assets/Yala.jpg'),
                    DestinationImage(imagePath: 'assets/Kandy.jpg'),
                  ],
                ),
              ),
              PromoBanner(
                title: 'Family Package',
                subtitle: 'Family Fun up to 20%',
                color: Color(0xFFAED581),
                onTap: () {}, // Add navigation if needed
              ),
              PromoBanner(
                title: 'Explore Activities',
                subtitle: 'Discover top adventure & cultural tours',
                color: Color(0xFF003734), // Dark Green
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ExploreActivitiesScreen()),
                  );
                },
              ),
              PromoBanner(
                title: 'Top Activities',
                subtitle: 'Find the best experiences',
                color: Colors.grey,
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
                onTap: () {}, // Add navigation if needed
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationImage extends StatelessWidget {
  final String imagePath;
  const DestinationImage({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        child: Image.asset(
          imagePath,
          width: 180, // Increased width (Adjust as needed)
          height: 140, // Increased height slightly
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap; // Function for navigation

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap, // Pass function for navigation
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Correctly handling navigation
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
