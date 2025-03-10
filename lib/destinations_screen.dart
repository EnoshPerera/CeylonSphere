import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/destination.dart';
import 'destination_detail_screen.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  _DestinationsScreenState createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Destination> _filteredDestinations = destinations; // Default full list

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDestinations);
  }

  void _filterDestinations() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredDestinations = destinations
          .where((destination) =>
              destination.name.toLowerCase().contains(query) ||
              destination.description.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Destinations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003734), // Dark Green Title
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search destinations...',
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),

            // Destination List
            Expanded(
              child: _filteredDestinations.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _filteredDestinations.length,
                      itemBuilder: (context, index) {
                        final destination = _filteredDestinations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => DestinationDetailScreen(
                                    destination: destination),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  destination.imagePath,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                destination.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                destination.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No destinations found.',
                        style: TextStyle(
                            fontSize: 18, color: CupertinoColors.systemGrey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
