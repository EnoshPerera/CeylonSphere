import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as polyline;
import 'place_selection_page.dart';

void main() => runApp(TravelBookingApp());

class TravelBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: BookingHomePage(),
    );
  }
}

class BookingHomePage extends StatefulWidget {
  @override
  _BookingHomePageState createState() => _BookingHomePageState();
}

class _BookingHomePageState extends State<BookingHomePage> {
  final _places = GoogleMapsPlaces(apiKey: 'AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA');
  final _pickupController = TextEditingController();
  final _dropOffController = TextEditingController();
  List<TextEditingController> _stopControllers = [];
  GoogleMapController? _mapController;
  String _tripType = 'One way';
  Set<Marker> _markers = {};
  List<LatLng> _selectedLocations = [];
  polyline.PolylinePoints polylinePoints = polyline.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  @override
  void dispose() {
    _pickupController.dispose();
    _dropOffController.dispose();
    _stopControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> _updateMapWithSelectedPlace(String placeId, String placeName, int index) async {
    final details = await _places.getDetailsByPlaceId(placeId);
    if (details.result != null) {
      final location = details.result!.geometry!.location;
      final latLng = LatLng(location.lat, location.lng);
      setState(() {
        if (_selectedLocations.length > index) {
          _selectedLocations[index] = latLng;
        } else {
          _selectedLocations.add(latLng);
        }
        _markers.add(
          Marker(
            markerId: MarkerId('location$index'),
            position: latLng,
            infoWindow: InfoWindow(title: placeName),
          ),
        );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
      if (_selectedLocations.length >= 2) {
        _getDirections();
      }
    }
  }

  Future<void> _getDirections() async {
    if (_selectedLocations.length < 2) return; // Ensure there are at least two points

    List<LatLng> polylineCoordinates = [];

    // Convert intermediate stops into PolylineWayPoint objects
    List<polyline.PolylineWayPoint> waypoints = _selectedLocations
        .sublist(1, _selectedLocations.length - 1) // Exclude first (pickup) and last (drop-off)
        .map((latLng) => polyline.PolylineWayPoint(
      location: "${latLng.latitude},${latLng.longitude}",
    ))
        .toList();

    polyline.PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA', // Replace with your Google Maps API key
      polyline.PointLatLng(_selectedLocations.first.latitude, _selectedLocations.first.longitude), // Pickup
      polyline.PointLatLng(_selectedLocations.last.latitude, _selectedLocations.last.longitude), // Drop-off
      travelMode: polyline.TravelMode.driving,
      wayPoints: waypoints, // Pass converted waypoints
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((polyline.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      polylines[PolylineId('route')] = Polyline(
        polylineId: PolylineId('route'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      );
    });
  }


  Widget _buildLocationField(String label, TextEditingController controller, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlaceSelectionPage(places: _places)),
            );
            if (result != null) {
              controller.text = result['name'];
              _updateMapWithSelectedPlace(result['placeId'], result['name'], index);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(7.8731, 80.7718), zoom: 7),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLocationField('Pickup Location', _pickupController, 0),
                  ..._stopControllers.asMap().entries.map((entry) => Row(
                    children: [
                      Expanded(child: _buildLocationField('Stop ${entry.key + 1}', entry.value, entry.key + 1)),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => setState(() => _stopControllers.removeAt(entry.key)),
                      ),
                    ],
                  )),
                  GestureDetector(
                    onTap: () => setState(() => _stopControllers.add(TextEditingController())),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('+ Add Stop', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  _buildLocationField('Drop-off Location', _dropOffController, _stopControllers.length + 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
