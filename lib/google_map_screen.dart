import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition =
      const LatLng(6.9271, 79.8612); // Default to Colombo, Sri Lanka
  Set<Marker> _markers = {};
  double _radiusInMeters = 1609; // Default: 1 mile (1 mile = 1609 meters)
  String apiKey = "AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s";
  // "AIzaSyAvS00_oarJDXlu9m0HajBH7qxGZA6RLy8"; // ❗ Replace with your API key (secure it in a .env file!)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation, 14),
      );

      _fetchNearbyPlaces(userLocation);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _fetchNearbyPlaces(LatLng location) async {
    final url =
        Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json"
            "?location=${location.latitude},${location.longitude}"
            "&radius=$_radiusInMeters" // ✅ Dynamic radius
            "&type=restaurant"
            "&key=$apiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] != "OK") {
          print("Google Places API Error: ${data["status"]}");
          return;
        }

        List results = data["results"];
        setState(() {
          _markers.clear();
          for (var place in results) {
            _markers.add(
              Marker(
                markerId: MarkerId(place["place_id"]),
                position: LatLng(
                  place["geometry"]["location"]["lat"],
                  place["geometry"]["location"]["lng"],
                ),
                infoWindow: InfoWindow(
                  title: place["name"],
                  snippet: place["vicinity"],
                ),
              ),
            );
          }
        });
      } else {
        print("API Request Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Find Places'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.search),
          onPressed: () => _fetchNearbyPlaces(_initialPosition),
        ),
      ),
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
          ),

          // Radius Selector (Dropdown)
          Positioned(
            top: 120, // Increased from 80 to 120 to move it lower
            left: 20,
            child: CupertinoSlidingSegmentedControl<double>(
              groupValue: _radiusInMeters,
              children: {
                1609.0: Text("1 Mile"),
                5000.0: Text("5 Miles"),
                10000.0: Text("10 Miles"),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    _radiusInMeters = value;
                    _fetchNearbyPlaces(_initialPosition);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
