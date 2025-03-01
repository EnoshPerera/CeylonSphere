// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class GoogleMapsPage extends StatefulWidget {
//   final double lat;
//   final double lng;
//   final String name;

//   const GoogleMapsPage({
//     required this.lat,
//     required this.lng,
//     required this.name,
//   });

//   @override
//   _GoogleMapsPageState createState() => _GoogleMapsPageState();
// }

// class _GoogleMapsPageState extends State<GoogleMapsPage> {
//   late GoogleMapController _mapController;
//   Set<Marker> _markers = {};
  
//   static const String apiKey = "AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s"; // Replace with your API key
//   late CameraPosition _initialPosition;
// //YAIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA
// //AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s
//   @override
//   void initState() {
//     super.initState();
//     _initialPosition = CameraPosition(
//       target: LatLng(widget.lat, widget.lng),
//       zoom: 14,
//     );
//     _getNearbyRestaurants();
//   }

//   Future<void> _getNearbyRestaurants() async {
//     final url = Uri.parse(
//       "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
//       "location=${widget.lat},${widget.lng}&radius=5000&type=restaurant&key=$apiKey",
//     );

//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final results = data['results'];

//       setState(() {
//         _markers = results.map<Marker>((restaurant) {
//           double lat = restaurant['geometry']['location']['lat'];
//           double lng = restaurant['geometry']['location']['lng'];
//           String name = restaurant['name'];
//           String address = restaurant['vicinity'];

//           return Marker(
//             markerId: MarkerId(name),
//             position: LatLng(lat, lng),
//             infoWindow: InfoWindow(title: name, snippet: address),
//           );
//         }).toSet();
//       });
//     } else {
//       print("Failed to load nearby restaurants");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.name)),
//       body: GoogleMap(
//         initialCameraPosition: _initialPosition,
//         onMapCreated: (controller) {
//           _mapController = controller;
//         },
//         markers: _markers,
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key, required double lat, required double lng, required String name}) : super(key: key);

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  List<dynamic> _restaurants = [];
  Position? _currentPosition;

  static const String apiKey = "AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s"; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Get User's Current Location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    // Move camera to current location
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 14));

    // Fetch nearby restaurants
    _getNearbyRestaurants(position.latitude, position.longitude);
  }

  /// Fetch Nearby Restaurants from Google Places API
  Future<void> _getNearbyRestaurants(double lat, double lng) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
      "location=$lat,$lng&radius=5000&type=restaurant&key=$apiKey",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      setState(() {
        _restaurants = results;
        _markers = results.map<Marker>((restaurant) {
          double lat = restaurant['geometry']['location']['lat'];
          double lng = restaurant['geometry']['location']['lng'];
          String name = restaurant['name'];
          String address = restaurant['vicinity'];

          return Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name, snippet: address),
          );
        }).toSet();
      });
    } else {
      print("Failed to load nearby restaurants");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Restaurants")),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator()) // Show loading before getting location
          : Column(
              children: [
                // Google Map
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      zoom: 7,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _getNearbyRestaurants(_currentPosition!.latitude, _currentPosition!.longitude);
                    },
                    markers: _markers,
                    myLocationEnabled: true, // Show user's current location on the map
                    myLocationButtonEnabled: true,
                  ),
                ),
                // List of nearby restaurants
                _restaurants.isNotEmpty
                    ? Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = _restaurants[index];
                            return ListTile(
                              title: Text(restaurant['name']),
                              subtitle: Text(restaurant['vicinity']),
                              onTap: () {
                                // Move map to selected restaurant
                                _mapController.animateCamera(
                                  CameraUpdate.newLatLng(
                                    LatLng(
                                      restaurant['geometry']['location']['lat'],
                                      restaurant['geometry']['location']['lng'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()), // Show loading while fetching data
              ],
            ),
    );
  }
}
