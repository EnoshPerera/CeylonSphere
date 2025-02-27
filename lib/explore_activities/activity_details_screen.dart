import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

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
    case 'climbing adam’s peak for sunrise':
      return CupertinoIcons.sunrise; // 🌄 Sunrise Hike
    case 'hiking to world’s end in horton plains':
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
                // Activity Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    activity['image'],
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Activity Types Section (Now with Taller Cards)
                const Text(
                  'Activity Types:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    activity['details']['activities'].length,
                    (index) {
                      String activityType =
                          activity['details']['activities'][index];
                      IconData icon = getActivityIcon(
                          activityType); // 🔹 Assign icon dynamically

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
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
                              color: CupertinoColors.systemGroupedBackground,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            height: 120, // Increased Height
                            child: Row(
                              children: [
                                // Left Icon
                                Icon(icon,
                                    size: 40,
                                    color: CupertinoColors.systemBlue),
                                const SizedBox(
                                    width: 16), // Spacing between icon & text

                                // Activity Type Name
                                Expanded(
                                  child: Text(
                                    activityType,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                // Right Arrow Icon
                                const Icon(
                                  CupertinoIcons.arrow_right_circle_fill,
                                  color: CupertinoColors.systemBlue,
                                  size: 28,
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
class ActivityPlacesScreen extends StatelessWidget {
  final String activityType;
  final List<String> places;

  const ActivityPlacesScreen({
    super.key,
    required this.activityType,
    required this.places,
  });

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          activityType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Places List
              Expanded(
                child: CupertinoListSection.insetGrouped(
                  children: List.generate(
                    places.length,
                    (index) {
                      String place = places[index];

                      return CupertinoListTile(
                        title: Text(
                          place,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _openGoogleMaps(place),
                          child: const Icon(
                            CupertinoIcons.location,
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
