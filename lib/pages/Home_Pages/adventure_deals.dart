import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdventureActivity {
  final String name;
  final String description;
  final String duration;
  final String price;
  final String link;
  final String imageUrl;

  AdventureActivity({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.link,
    this.imageUrl = '',
  });
}

class AdventureDealsPage extends StatefulWidget {
  const AdventureDealsPage({super.key});

  @override
  State<AdventureDealsPage> createState() => _AdventureDealsPageState();
}

class _AdventureDealsPageState extends State<AdventureDealsPage> {
  final List<AdventureActivity> activities = [
    AdventureActivity(
      name: "White Water Rafting in Kitulgala",
      description:
          "Experience the thrill of white water rafting on the Kelani River in Kitulgala, suitable for both beginners and seasoned rafters.",
      duration: "2-3 hours",
      price: "\$30",
      link: "https://www.rapidadventures.lk/",
      imageUrl:
          "https://images.unsplash.com/photo-1530866495561-507c9faab2ed?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Trekking in Knuckles Mountain Range",
      description:
          "Embark on a trekking adventure in the Knuckles Mountain Range, exploring diverse flora, fauna, and breathtaking landscapes.",
      duration: "Full day",
      price: "\$50",
      link:
          "https://www.ceylontraveldream.com/adventure-activities-in-sri-lanka.php",
      imageUrl:
          "https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Camping in Knuckles Mountain Range",
      description:
          "Experience overnight camping in the Knuckles Mountain Range, immersing yourself in nature and enjoying the tranquility of the wilderness.",
      duration: "2 days",
      price: "\$118",
      link:
          "https://www.tripadvisor.com/Attractions-g293961-Activities-c61-t212-oa60-Sri_Lanka.html",
      imageUrl:
          "https://images.unsplash.com/photo-1504851149312-7a075b496cc7?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Safari in Yala National Park",
      description:
          "Join a safari in Yala National Park to spot leopards, elephants, and a variety of wildlife in their natural habitat.",
      duration: "Full day",
      price: "\$60",
      link:
          "https://www.tripadvisor.com/Attractions-g293961-Activities-c61-Sri_Lanka.html",
      imageUrl:
          "https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Scuba Diving in Kalpitiya",
      description:
          "Explore the underwater world of Kalpitiya with scuba diving adventures, discovering vibrant coral reefs and marine life.",
      duration: "Varies",
      price: "Varies",
      link: "https://en.wikipedia.org/wiki/Kalpitiya",
      imageUrl:
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Hiking Adam's Peak (Sri Pada)",
      description:
          "Climb the sacred Adam's Peak, a pilgrimage site offering panoramic views and a rewarding hiking experience.",
      duration: "7-8 hours",
      price: "Varies",
      link: "https://www.tourradar.com/i/sri-lanka-adventure",
      imageUrl:
          "https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Surfing in Arugam Bay",
      description:
          "Catch the waves at Arugam Bay, one of Sri Lanka's premier surfing destinations suitable for all skill levels.",
      duration: "Varies",
      price: "Varies",
      link:
          "https://elpais.com/elviajero/lonely-planet/2024-10-10/sri-lanka-un-destino-al-alza-para-los-aficionados-al-surf.html",
      imageUrl:
          "https://images.unsplash.com/photo-1502680390469-be75c86b636f?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Caving in Batadombalena",
      description:
          "Explore the ancient caves of Batadombalena, rich in archaeological significance and natural beauty.",
      duration: "Half day",
      price: "\$40",
      link:
          "https://www.ceylontraveldream.com/adventure-activities-in-sri-lanka.php",
      imageUrl:
          "https://images.unsplash.com/photo-1504542982118-59308b40fe0c?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Cycling Tour in Galle",
      description:
          "Discover the historic city of Galle and its surroundings on a guided cycling tour, experiencing local culture and scenic routes.",
      duration: "3-4 hours",
      price: "\$25",
      link:
          "https://www.ceylontraveldream.com/adventure-activities-in-sri-lanka.php",
      imageUrl:
          "https://images.unsplash.com/photo-1541625602330-2277a4c46182?q=80&w=500&auto=format&fit=crop",
    ),
    AdventureActivity(
      name: "Kitesurfing in Kalpitiya",
      description:
          "Enjoy kitesurfing in Kalpitiya, known for its ideal wind conditions and beautiful coastal scenery.",
      duration: "Varies",
      price: "Varies",
      link: "https://en.wikipedia.org/wiki/Kalpitiya",
      imageUrl:
          "https://images.unsplash.com/photo-1580628567835-1b09b3d95d6c?q=80&w=500&auto=format&fit=crop",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Adventure Deals'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        brightness: Brightness.dark,
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: AdventureCard(activity: activities[index]),
                    );
                  },
                  childCount: activities.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdventureCard extends StatelessWidget {
  final AdventureActivity activity;

  const AdventureCard({super.key, required this.activity});

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Could not launch $url'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(activity.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 16),
                // Details
                Row(
                  children: [
                    // Duration
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.time,
                            size: 16,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            activity.duration,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.money_dollar,
                            size: 16,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            activity.price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () => _launchURL(context, activity.link),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Explicitly setting text color
                      ),
                    ),
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
