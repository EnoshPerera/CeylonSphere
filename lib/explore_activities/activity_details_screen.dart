import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Favorites Manager to handle favorites globally
class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final Set<Map<String, dynamic>> _favorites = {};

  Set<Map<String, dynamic>> get favorites => _favorites;

  void toggleFavorite(Map<String, dynamic> place) {
    if (_favorites.any((element) => element['name'] == place['name'])) {
      _favorites.removeWhere((element) => element['name'] == place['name']);
    } else {
      _favorites.add(place);
    }
    notifyListeners();
  }

  bool isFavorite(String placeName) {
    return _favorites.any((element) => element['name'] == placeName);
  }
}

// Favorites Screen
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Favorite Destinations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: FavoritesManager(),
          builder: (context, child) {
            final favorites = FavoritesManager().favorites;

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.heart,
                      size: 64,
                      color: CupertinoColors.systemGrey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start adding destinations to your favorites!',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final place = favorites.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                place['image'] ??
                                    'assets/images/placeholder.jpg',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              // Remove from Favorites Button
                              Positioned(
                                top: 16,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () =>
                                      FavoritesManager().toggleFavorite(place),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.white
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.heart_fill,
                                      color: CupertinoColors.systemRed,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                place['activityType'] ?? '',
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CupertinoButton.filled(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                onPressed: () {
                                  // Navigate to detailed view or open in maps
                                  if (place['location'] != null) {
                                    launchUrl(Uri.parse(
                                        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place['location'])}"));
                                  }
                                },
                                child: const Text('View Details'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// 🔹 Place the function here (before ActivityDetailsScreen class)
IconData getActivityIcon(String activity) {
  switch (activity.toLowerCase()) {
    case 'sunbathing and swimming':
      return CupertinoIcons.sun_max; // ☀️ Sunbathing & Swimming
    case 'snorkeling and scuba diving':
      return IconData(0xf06cf,
          fontFamily: 'MaterialIcons'); // 🌊 Snorkeling & Scuba Diving
    case 'whale and dolphin watching':
      return CupertinoIcons.eye; // 🐋 Watching Animals
    case 'jet skiing, kayaking, and windsurfing':
      return CupertinoIcons.wind; // 🏄‍♂️ Water Sports
    case 'spotting leopards, elephants, and sloth bears':
      return CupertinoIcons.paw; // 🦁 Wildlife Safari
    case 'birdwatching':
      return CupertinoIcons.tree; // 🦜 Birdwatching
    case 'elephant sightings':
      return CupertinoIcons.paw; // 🐘 Elephant Safari
    case 'jungle trekking and nature walks':
      return CupertinoIcons.tree; // 🌳 Jungle Trekking
    case 'visiting ancient temples and stupas':
      return CupertinoIcons.book; // 🏛️ Cultural Sites
    case 'exploring the sigiriya rock fortress':
      return CupertinoIcons.tree; // ⛰️ Sigiriya
    case 'touring the temple of the tooth relic':
      return CupertinoIcons.heart; // 🏯 Temple Tour
    case 'walking through the galle fort':
      return CupertinoIcons.map; // 🏰 Galle Fort
    case 'discovering cave temples':
      return CupertinoIcons.compass; // 🕍 Cave Exploration
    case 'climbing adam peak for sunrise':
      return CupertinoIcons.sunrise; // 🌄 Sunrise Hike
    case 'hiking to worlds end in horton plains':
      return CupertinoIcons.arrow_up_right; // 🏔️ Mountain Hiking
    case 'trekking through tea plantations':
      return CupertinoIcons.tree; // 🍃 Tea Plantation Trek
    case 'exploring the knuckles mountain range':
      return CupertinoIcons.hare; // 🏞️ Mountain Adventure
    case 'enjoying beach parties and nightclubs':
      return CupertinoIcons.music_note; // 🎵 Nightlife
    case 'experiencing live music and cultural shows':
      return CupertinoIcons.mic; // 🎤 Live Music
    default:
      return CupertinoIcons.circle; // 🔘 Default Icon
  }
}

// 🔹 Below this function, your ActivityDetailsScreen class starts
class ActivityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityDetailsScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          activity['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trending Activities Carousel
                SizedBox(
                  height: 200, // Increased height to accommodate description
                  child: PageView.builder(
                    itemCount: 3, // Number of trending items
                    controller: PageController(viewportFraction: 0.93),
                    itemBuilder: (context, index) {
                      // Demo data - In real app, this would come from your data source
                      final List<Map<String, String>> trendingItems = [
                        {
                          'image': activity['image'],
                          'title': 'Special Offer',
                          'description':
                              '20% off on group bookings this weekend!',
                          'tag': 'LIMITED TIME'
                        },
                        {
                          'image': activity['image'],
                          'title': 'Trending Now',
                          'description': 'Most popular activity this season',
                          'tag': 'TRENDING'
                        },
                        {
                          'image': activity['image'],
                          'title': 'New Experience',
                          'description': 'Newly added adventure package',
                          'tag': 'NEW'
                        },
                      ];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    CupertinoColors.systemGrey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  trendingItems[index]['image']!,
                                  width: double.infinity,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient Overlay
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                              // Content
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tag
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGreen,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        trendingItems[index]['tag']!,
                                        style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Title
                                    Text(
                                      trendingItems[index]['title']!,
                                      style: const TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Description
                                    Text(
                                      trendingItems[index]['description']!,
                                      style: const TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Page Indicator
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${index + 1}/3',
                                    style: const TextStyle(
                                      color: CupertinoColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Activity Types Section (Now with Taller Cards)
                // const Text(
                //   'Activity Types:',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    activity['details']['activities'].length,
                    (index) {
                      String activityType =
                          activity['details']['activities'][index];
                      IconData icon = getActivityIcon(activityType);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ActivityPlacesScreen(
                                  activityType: activityType,
                                  places: activity['details']['places'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFE8F4F8),
                                  Color(0xFFF0F8FF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            height: 130,
                            child: Row(
                              children: [
                                // Icon Container
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGreen
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 32,
                                    color: CupertinoColors.systemGreen,
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        activityType,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors.systemGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to explore locations',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.systemGrey
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right Arrow with Container
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGreen
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.arrow_right,
                                    color: CupertinoColors.systemGreen,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Back Button
                Center(
                  child: CupertinoButton.filled(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 New Screen to Show Places
class ActivityPlacesScreen extends StatefulWidget {
  final String activityType;
  final List<String> places;

  const ActivityPlacesScreen({
    super.key,
    required this.activityType,
    required this.places,
  });

  @override
  State<ActivityPlacesScreen> createState() => _ActivityPlacesScreenState();
}

class _ActivityPlacesScreenState extends State<ActivityPlacesScreen> {
  void _toggleFavorite(String place) {
    FavoritesManager().toggleFavorite({
      'name': place,
      'activityType': widget.activityType,
      'image': 'assets/images/placeholder.jpg', // Replace with actual image
      'location': place,
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.activityType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        previousPageTitle: 'Back',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const FavoritesScreen(),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.heart_fill,
            color: CupertinoColors.systemRed,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Discover Amazing Destinations',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemGreen,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: widget.places.length,
                itemBuilder: (context, index) {
                  String place = widget.places[index];
                  bool isFavorite = FavoritesManager().isFavorite(place);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Image.asset(
                                  getDestinationImage(place),
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback image in case of error
                                    return Image.asset(
                                      'assets/sunbathing.jpg',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                // Favorite Button Overlay
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: GestureDetector(
                                    onTap: () => _toggleFavorite(place),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.white
                                            .withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Icon(
                                        isFavorite
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color: isFavorite
                                            ? CupertinoColors.systemRed
                                            : CupertinoColors.systemGrey,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location Name
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        place,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _openGoogleMaps(place),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.systemGreen
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.location,
                                          color: CupertinoColors.systemGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Available Activities
                                const Text(
                                  'Available Activities:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildActivityChip(widget.activityType),
                                    _buildActivityChip('Photography'),
                                    _buildActivityChip('Guided Tours'),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Best Time to Visit
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.clock,
                                      size: 20,
                                      color: CupertinoColors.systemGreen,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Best Time: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '6:00 AM - 6:00 PM',
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Duration
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.time,
                                      size: 20,
                                      color: CupertinoColors.systemGreen,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Duration: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '2-3 hours',
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey
                                            .withOpacity(0.8),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CupertinoColors.systemGreen.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CupertinoColors.systemGreen,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Function to open Google Maps
  void _openGoogleMaps(String location) async {
    final encodedLocation = Uri.encodeComponent(location);
    final url =
        "https://www.google.com/maps/search/?api=1&query=$encodedLocation";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Could not open Google Maps");
    }
  }
}

// Add this function before ActivityPlacesScreen class
String getDestinationImage(String place) {
  // Mapping of destinations to their specific images
  final Map<String, String> destinationImages = {
    'Unawatuna Beach': 'assets/sunbathing.jpg',
    'Mirissa Beach': 'assets/images/mirissa_beach.jpg',
    'Arugam Bay': 'assets/images/arugam_bay.jpg',
    'Hikkaduwa Beach': 'assets/images/hikkaduwa_beach.jpg',
    'Bentota Beach': 'assets/images/bentota_beach.jpg',
    'Yala National Park': 'assets/images/yala_national_park.jpg',
    'Udawalawe National Park': 'assets/images/udawalawe_national_park.jpg',
    'Minneriya National Park': 'assets/images/minneriya_national_park.jpg',
    'Wilpattu National Park': 'assets/images/wilpattu_national_park.jpg',
    'Sinharaja Forest': 'assets/images/sinharaja_forest.jpg',
    'Temple of the Tooth': 'assets/images/temple_of_tooth.jpg',
    'Sigiriya Rock Fortress': 'assets/images/sigiriya_rock.jpg',
    'Dambulla Cave Temple': 'assets/images/dambulla_cave.jpg',
    'Galle Fort': 'assets/images/galle_fort.jpg',
    'Polonnaruwa Ancient City': 'assets/images/polonnaruwa.jpg',
    'Adams Peak': 'assets/images/adams_peak.jpg',
    'Horton Plains': 'assets/images/horton_plains.jpg',
    'Ella Rock': 'assets/images/ella_rock.jpg',
    'Knuckles Mountain Range': 'assets/images/knuckles_mountain.jpg',
    'Nuwara Eliya Tea Plantations': 'assets/images/nuwara_eliya_tea.jpg'
  };

  // Return the specific image for the destination, or a default image if not found
  return destinationImages[place] ?? 'assets/images/default_destination.jpg';
}
