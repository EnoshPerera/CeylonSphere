import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantMapScreen extends StatefulWidget {
  final LatLng? userLocation;

  const RestaurantMapScreen({Key? key, this.userLocation}) : super(key: key);

  @override
  _RestaurantMapScreenState createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  static const String _apiKey = "AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s";

  @override
  void initState() {
    super.initState();
    _fetchNearbyRestaurants();
  }

  Future<void> _fetchNearbyRestaurants() async {
    if (widget.userLocation == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.userLocation!.latitude},${widget.userLocation!.longitude}&radius=5000&type=restaurant&key=$_apiKey';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      Set<Marker> newMarkers = results.map((place) {
        final double lat = place['geometry']['location']['lat'];
        final double lng = place['geometry']['location']['lng'];
        final String name = place['name'];

        return Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
        );
      }).toSet();

      setState(() {
        _markers = newMarkers;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Restaurants")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.userLocation ?? LatLng(7.8731, 80.7718),
          zoom: 12.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }
}
