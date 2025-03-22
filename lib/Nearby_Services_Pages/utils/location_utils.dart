import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';

class LocationUtils {
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final lat1 = point1.latitude * math.pi / 180;
    final lat2 = point2.latitude * math.pi / 180;
    final dLat = (point2.latitude - point1.latitude) * math.pi / 180;
    final dLon = (point2.longitude - point1.longitude) * math.pi / 180;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static String getPlaceType(String category) {
    return placeTypes[category] ?? 'point_of_interest';
  }

  static BitmapDescriptor getMarkerIcon(String category) {
    switch (category) {
      case 'Tourist Spots':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Restaurants':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      case 'Hotels':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'Shopping':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case 'Grocery':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'Liquor Stores':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Tourist Spots':
        return Icons.photo_camera;
      case 'Restaurants':
        return Icons.restaurant;
      case 'Hotels':
        return Icons.hotel;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Grocery':
        return Icons.local_grocery_store;
      case 'Liquor Stores':
        return Icons.local_bar;
      default:
        return Icons.place;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Tourist Spots':
        return Colors.green;
      case 'Restaurants':
        return Colors.pink;
      case 'Hotels':
        return Colors.blue;
      case 'Shopping':
        return Colors.purple;
      case 'Grocery':
        return Colors.orange;
      case 'Liquor Stores':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 