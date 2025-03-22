import 'package:ceylonsphere/explore_activities/activity_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final Set<Map<String, dynamic>> _favorites = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoaded = false;

  Set<Map<String, dynamic>> get favorites => _favorites;

  String get _userId {
    final user = _auth.currentUser;
    return user?.uid ?? 'anonymous_user';
  }

  Future<void> initializeFavorites() async {
    if (_isLoaded) return;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .get();

      _favorites.clear();
      for (var doc in snapshot.docs) {
        _favorites.add(doc.data());
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites from Firebase: $e');
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> place) async {
    final placeWithImage = {
      ...place,
      'image': getDestinationImage(place['name']),
    };

    final alreadyFavorite =
        _favorites.any((element) => element['name'] == place['name']);

    if (alreadyFavorite) {
      _favorites.removeWhere((element) => element['name'] == place['name']);
      await _removeFavoriteFromFirebase(place['name']);
    } else {
      _favorites.add(placeWithImage);
      await _addFavoriteToFirebase(placeWithImage);
    }
    notifyListeners();
  }

  Future<void> _addFavoriteToFirebase(Map<String, dynamic> place) async {
    try {
      final docId = place['name'].toString().replaceAll(' ', '_').toLowerCase();
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(docId)
          .set(place);
    } catch (e) {
      debugPrint('Error adding favorite to Firebase: $e');
    }
  }

  Future<void> _removeFavoriteFromFirebase(String placeName) async {
    try {
      final docId = placeName.replaceAll(' ', '_').toLowerCase();
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(docId)
          .delete();
    } catch (e) {
      debugPrint('Error removing favorite from Firebase: $e');
    }
  }

  bool isFavorite(String placeName) {
    return _favorites.any((element) => element['name'] == placeName);
  }
}

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
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                place['image'] ??
                                    getDestinationImage(place['name']),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/placeholder.jpg',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
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
                                  if (place['location'] != null) {
                                    final url = Uri.parse(
                                      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place['location'])}",
                                    );
                                    launchUrl(url);
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
