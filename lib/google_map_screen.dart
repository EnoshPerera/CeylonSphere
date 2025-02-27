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
  String apiKey =
      "AIzaSyAvS00_oarJDXlu9m0HajBH7qxGZA6RLy8"; // Replace with your API key

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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng userLocation = LatLng(position.latitude, position.longitude);

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(userLocation, 14),
    );

    _fetchNearbyRestaurants(userLocation);
  }

  Future<void> _fetchNearbyRestaurants(LatLng location) async {
    final url =
        Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json"
            "?location=${location.latitude},${location.longitude}"
            "&radius=10000" // 10km radius
            "&type=restaurant"
            "&key=$apiKey");

    final response = await http.get(url);
    print("API Response: ${response.body}"); // Debugging line

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
          final marker = Marker(
            markerId: MarkerId(place["place_id"]),
            position: LatLng(
              place["geometry"]["location"]["lat"],
              place["geometry"]["location"]["lng"],
            ),
            infoWindow: InfoWindow(
              title: place["name"],
              snippet: place["vicinity"],
            ),
          );
          _markers.add(marker);
        }
      });
      print("Markers Added: ${_markers.length}");
    } else {
      print("API Request Failed with Status Code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Find Places'),
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
        ],
      ),
    );
  }
}
