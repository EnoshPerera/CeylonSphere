import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String name;
  final String category;
  final LatLng location;
  final String description;
  final double rating;
  final double distance;
  final String address;
  final String photoReference;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.rating,
    this.distance = 0,
    required this.address,
    this.photoReference = '',
  });

  factory Place.fromGooglePlace(Map<String, dynamic> place, String category) {
    final location = place['geometry']['location'];
    return Place(
      id: place['place_id'],
      name: place['name'],
      category: category,
      location: LatLng(location['lat'], location['lng']),
      description: place['vicinity'] ?? '',
      rating: (place['rating'] ?? 0.0).toDouble(),
      address: place['vicinity'] ?? '',
      photoReference: place['photos']?[0]?['photo_reference'] ?? '',
    );
  }
} 