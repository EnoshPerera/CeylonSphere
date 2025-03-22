import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../models/place.dart';
import '../constants/api_constants.dart';
import '../utils/location_utils.dart';

class PlacesService {
  final Dio _dio = Dio();

  Future<List<Place>> getNearbyPlaces({
    required LatLng location,
    required String category,
    required double radius,
  }) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '${location.latitude},${location.longitude}',
          'radius': radius,
          'type': LocationUtils.getPlaceType(category),
          'key': apiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final results = response.data['results'] as List;
        return results
            .map((place) => Place.fromGooglePlace(place, category))
            .toList();
      } else {
        throw Exception('Failed to load places: ${response.data['status']}');
      }
    } catch (e) {
      throw Exception('Error loading places: $e');
    }
  }

  Future<Map<String, dynamic>> getDirections({
    required LatLng origin,
    required LatLng destination,
    required String travelMode,
  }) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'mode': travelMode,
          'key': apiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final route = response.data['routes'][0];
        final leg = route['legs'][0];
        final polylinePoints = PolylinePoints();
        final points = polylinePoints.decodePolyline(route['overview_polyline']['points']);

        return {
          'polyline_points': points.map((point) => LatLng(point.latitude, point.longitude)).toList(),
          'bounds': {
            'southwest': LatLng(
              route['bounds']['southwest']['lat'],
              route['bounds']['southwest']['lng'],
            ),
            'northeast': LatLng(
              route['bounds']['northeast']['lat'],
              route['bounds']['northeast']['lng'],
            ),
          },
          'distance': leg['distance']['text'],
          'duration': leg['duration']['text'],
          'start_address': leg['start_address'],
          'end_address': leg['end_address'],
        };
      } else {
        throw Exception('Failed to load directions: ${response.data['status']}');
      }
    } catch (e) {
      throw Exception('Error loading directions: $e');
    }
  }
} 