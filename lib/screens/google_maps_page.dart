import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPage extends StatefulWidget {
  final double lat;
  final double lng;
  final String name;

  const GoogleMapsPage({required this.lat, required this.lng, required this.name});

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.name),
            position: LatLng(widget.lat, widget.lng),
            infoWindow: InfoWindow(title: widget.name),
          ),
        },
      ),
    );
  }
}
