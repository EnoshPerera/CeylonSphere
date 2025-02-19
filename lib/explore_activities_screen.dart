import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreActivitiesScreen extends StatefulWidget {
  const ExploreActivitiesScreen({super.key});

  @override
  _ExploreActivitiesScreenState createState() =>
      _ExploreActivitiesScreenState();
}

class _ExploreActivitiesScreenState extends State<ExploreActivitiesScreen> {
  String selectedCategory = 'All';
  String selectedLocation = 'All';
  String selectedDifficulty = 'All';
  String selectedDuration = 'All';

  final List<Map<String, dynamic>> activities = [
    {
      'name': 'Historical Tour',
      'image': 'assets/Kandy.jpg',
      'category': 'Historical',
      'location': 'Sri Lanka',
      'difficulty': 'Easy',
      'duration': 'Full Day',
    },
    {
      'name': 'Eco-Tourism Hike',
      'image': 'assets/Yala.jpg',
      'category': 'Eco-Tourism',
      'location': 'Ella',
      'difficulty': 'Moderate',
      'duration': 'Half Day',
    },
    {
      'name': 'Scuba Diving',
      'image': 'assets/Kandy.jpg',
      'category': 'Adventure',
      'location': 'Galle',
      'difficulty': 'Hard',
      'duration': 'Half Day',
    },
    {
      'name': 'Mountain Trekking',
      'image': 'assets/Yala.jpg',
      'category': 'Adventure',
      'location': 'Kandy',
      'difficulty': 'Hard',
      'duration': 'Full Day',
    },
    {
      'name': 'Cultural Tour',
      'image': 'assets/Kandy.jpg',
      'category': 'Historical',
      'location': 'Colombo',
      'difficulty': 'Easy',
      'duration': 'Full Day',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredActivities =
        activities.where((activity) {
      return (selectedCategory == 'All' ||
              activity['category'] == selectedCategory) &&
          (selectedLocation == 'All' ||
              activity['location'] == selectedLocation) &&
          (selectedDifficulty == 'All' ||
              activity['difficulty'] == selectedDifficulty) &&
          (selectedDuration == 'All' ||
              activity['duration'] == selectedDuration);
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Explore Activities',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003734)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildFilterDropdown(
                      'Category',
                      ['All', 'Historical', 'Adventure', 'Eco-Tourism'],
                      (value) => setState(() => selectedCategory = value)),
                  _buildFilterDropdown(
                      'Location',
                      ['All', 'Sri Lanka', 'Ella', 'Galle', 'Kandy', 'Colombo'],
                      (value) => setState(() => selectedLocation = value)),
                  _buildFilterDropdown(
                      'Difficulty',
                      ['All', 'Easy', 'Moderate', 'Hard'],
                      (value) => setState(() => selectedDifficulty = value)),
                  _buildFilterDropdown(
                      'Duration',
                      ['All', 'Half Day', 'Full Day'],
                      (value) => setState(() => selectedDuration = value)),
                ],
              ),
            ),

            // Activity Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredActivities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final activity = filteredActivities[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to details (You can create an activity detail screen if needed)
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: Image.asset(
                              activity['image'],
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              activity['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
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

  Widget _buildFilterDropdown(
      String label, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CupertinoButton(
            child: Text(options.contains(selectedCategory)
                ? selectedCategory
                : options.first),
            onPressed: () => _showFilterDialog(label, options, onChanged),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(
      String title, List<String> options, Function(String) onSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(title),
        actions: options.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              onSelected(option);
              Navigator.pop(context);
            },
            child: Text(option),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
