import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    as polyline;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Payment_Pages/consts.dart';
import 'vehicle_selection_page.dart';
import 'transport_final_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized();
  Stripe.publishableKey =
      stripePublishableKey; // Initialize Stripe with the publishable key


  runApp(TransportScreen());
}

class TransportScreen extends StatelessWidget {
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
  final _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA');
  final String _apiKey = 'AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA';
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<LatLng> _selectedLocations = [];
  polyline.PolylinePoints polylinePoints = polyline.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  String? pickupLocation;
  List<StopLocation> stopLocations = [];
  String? dropoffLocation;

  String? tripDistance;
  String? tripDuration;
  bool isCalculatingRoute = false;

  bool _isLocationSelectionOpen = false;

  Future<void> _updateMapWithSelectedPlace(
      String placeId, String placeName, String type,
      [int? stopIndex]) async {
    final details = await _places.getDetailsByPlaceId(placeId);
    if (details.result != null) {
      final location = details.result!.geometry!.location;
      final latLng = LatLng(location.lat, location.lng);
      setState(() {
        if (type == 'pickup') {
          pickupLocation = placeName;
          if (_selectedLocations.isEmpty) {
            _selectedLocations.add(latLng);
          } else {
            _selectedLocations[0] = latLng;
          }
          _markers.removeWhere((marker) => marker.markerId.value == 'pickup');
          _markers.add(Marker(
            markerId: MarkerId('pickup'),
            position: latLng,
            infoWindow: InfoWindow(title: 'Pickup: $placeName'),
          ));
        } else if (type == 'stop') {
          if (stopIndex != null && stopIndex < stopLocations.length) {
            stopLocations[stopIndex].name = placeName;
            int mapIndex = 1 + stopIndex;
            if (_selectedLocations.length > mapIndex) {
              _selectedLocations[mapIndex] = latLng;
            } else {
              _selectedLocations.add(latLng);
            }
            _markers.removeWhere(
                (marker) => marker.markerId.value == 'stop_$stopIndex');
            _markers.add(Marker(
              markerId: MarkerId('stop_$stopIndex'),
              position: latLng,
              infoWindow: InfoWindow(title: 'Stop: $placeName'),
            ));
          }
        } else if (type == 'dropoff') {
          dropoffLocation = placeName;
          if (_selectedLocations.length > stopLocations.length + 1) {
            _selectedLocations[stopLocations.length + 1] = latLng;
          } else {
            _selectedLocations.add(latLng);
          }
          _markers.removeWhere((marker) => marker.markerId.value == 'dropoff');
          _markers.add(Marker(
            markerId: MarkerId('dropoff'),
            position: latLng,
            infoWindow: InfoWindow(title: 'Dropoff: $placeName'),
          ));
        }
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));

      if (pickupLocation != null && dropoffLocation != null) {
        _generateRoute();
      }
    }
  }

  void _generateRoute() async {
    if (_selectedLocations.length < 2) return;

    setState(() {
      polylines.clear();
      isCalculatingRoute = true;
      tripDistance = null;
      tripDuration = null;
    });

    List<LatLng> routeCoords = [];
    int totalDistanceMeters = 0;
    int totalDurationSeconds = 0;

    for (int i = 0; i < _selectedLocations.length - 1; i++) {
      var result = await polylinePoints.getRouteBetweenCoordinates(
        _apiKey,
        polyline.PointLatLng(
            _selectedLocations[i].latitude, _selectedLocations[i].longitude),
        polyline.PointLatLng(_selectedLocations[i + 1].latitude,
            _selectedLocations[i + 1].longitude),
      );

      if (result.points.isNotEmpty) {
        routeCoords
            .addAll(result.points.map((e) => LatLng(e.latitude, e.longitude)));
      }

      try {
        final response = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/directions/json?'
            'origin=${_selectedLocations[i].latitude},${_selectedLocations[i].longitude}'
            '&destination=${_selectedLocations[i + 1].latitude},${_selectedLocations[i + 1].longitude}'
            '&key=$_apiKey'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            final leg = route['legs'][0];

            totalDistanceMeters += leg['distance']['value'] as int;
            totalDurationSeconds += leg['duration']['value'] as int;
          }
        }
      } catch (e) {
        print('Error getting directions: $e');
      }
    }

    double distanceKm = totalDistanceMeters / 1000.0;
    String formattedDistance = '${distanceKm.toStringAsFixed(1)} km';
    String formattedDuration = _formatDuration(totalDurationSeconds);

    setState(() {
      polylines[PolylineId("route")] = Polyline(
        polylineId: PolylineId("route"),
        points: routeCoords,
        color: Colors.blue,
        width: 5,
      );

      tripDistance = formattedDistance;
      tripDuration = formattedDuration;
      isCalculatingRoute = false;
    });
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else if (seconds < 3600) {
      return '${(seconds / 60).floor()} min';
    } else {
      int hours = (seconds / 3600).floor();
      int minutes = ((seconds % 3600) / 60).floor();
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}';
    }
  }

  void _addStopLocation() {
    setState(() {
      stopLocations.add(StopLocation());
    });
  }

  void _removeStopLocation(int index) {
    setState(() {
      stopLocations.removeAt(index);
      if (_selectedLocations.length > index + 1) {
        _selectedLocations.removeAt(index + 1);
      }
      _markers.removeWhere((marker) => marker.markerId.value == 'stop_$index');

      for (int i = index; i < stopLocations.length; i++) {
        _markers
            .removeWhere((marker) => marker.markerId.value == 'stop_${i + 1}');
        if (i + 1 < _selectedLocations.length - 1) {
          _markers.add(Marker(
            markerId: MarkerId('stop_$i'),
            position: _selectedLocations[i + 1],
            infoWindow: InfoWindow(title: 'Stop: ${stopLocations[i].name}'),
          ));
        }
      }

      if (pickupLocation != null && dropoffLocation != null) {
        _generateRoute();
      }
    });
  }

  void _toggleLocationSelection() {
    setState(() {
      _isLocationSelectionOpen = !_isLocationSelectionOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(7.8731, 80.7718), zoom: 7),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          if (!_isLocationSelectionOpen)
            Positioned(
              bottom: 100,
              left: 15,
              right: 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _toggleLocationSelection,
                child: Text('Book Your Trip',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          if (_isLocationSelectionOpen)
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Where do you want to go?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: _toggleLocationSelection,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          LocationInputField(
                            hint: 'Pickup Location',
                            places: _places,
                            initialValue: pickupLocation,
                            onPlaceSelected: (placeId, name) =>
                                _updateMapWithSelectedPlace(
                                    placeId, name, 'pickup'),
                          ),
                          SizedBox(height: 10),
                          ...List.generate(stopLocations.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: LocationInputField(
                                      hint: 'Stop Location',
                                      places: _places,
                                      initialValue: stopLocations[index].name,
                                      onPlaceSelected: (placeId, name) =>
                                          _updateMapWithSelectedPlace(
                                              placeId, name, 'stop', index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Center(
                            child: TextButton.icon(
                              icon: Icon(Icons.add),
                              label: Text('Add Stop'),
                              onPressed: _addStopLocation,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          LocationInputField(
                            hint: 'Drop-off Location',
                            places: _places,
                            initialValue: dropoffLocation,
                            onPlaceSelected: (placeId, name) =>
                                _updateMapWithSelectedPlace(
                                    placeId, name, 'dropoff'),
                          ),
                          SizedBox(height: 10),
                          if (isCalculatingRoute)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                        color: Colors.teal),
                                    SizedBox(height: 8),
                                    Text('Calculating route...',
                                        style: TextStyle(color: Colors.teal)),
                                  ],
                                ),
                              ),
                            )
                          else if (tripDistance != null && tripDuration != null)
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.teal.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.route, color: Colors.teal),
                                      SizedBox(height: 4),
                                      Text(tripDistance!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Distance',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600])),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.access_time,
                                          color: Colors.teal),
                                      SizedBox(height: 4),
                                      Text(tripDuration!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Duration',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: Size(double.infinity, 50),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (pickupLocation != null &&
                                  dropoffLocation != null) {
                                _toggleLocationSelection(); // Close the location panel

                                // Prepare stop location names
                                List<String> stopNames = stopLocations
                                    .where((stop) => stop.name != null)
                                    .map((stop) => stop.name!)
                                    .toList();

                                // Navigate to vehicle selection page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VehicleSelectionPage(
                                      pickupLocation: pickupLocation!,
                                      dropoffLocation: dropoffLocation!,
                                      stopLocations: stopNames,
                                      distance: tripDistance ?? 'Unknown',
                                      duration: tripDuration ?? 'Unknown',
                                      onPaymentSuccess: (String vehicleType,
                                          double amount,
                                          String paymentId,
                                          String userId) async {
                                        await saveTransportDetails(
                                          pickupLocation: pickupLocation!,
                                          dropoffLocation: dropoffLocation!,
                                          stopLocations: stopNames,
                                          distance: tripDistance ?? 'Unknown',
                                          duration: tripDuration ?? 'Unknown',
                                          vehicleType: vehicleType,
                                          totalAmount: amount,
                                          paymentId: paymentId,
                                          userId: userId,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Please select pickup and dropoff locations')));
                              }
                            },
                            child: Text('Confirm Route',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class StopLocation {
  String? name;
  StopLocation({this.name});
}

class LocationInputField extends StatefulWidget {
  final String hint;
  final GoogleMapsPlaces places;
  final Function(String placeId, String name) onPlaceSelected;
  final String? initialValue;

  LocationInputField({
    required this.hint,
    required this.places,
    required this.onPlaceSelected,
    this.initialValue,
  });

  @override
  _LocationInputFieldState createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  TextEditingController _controller = TextEditingController();
  List<PlacesSearchResult> _searchResults = [];
  bool _showSuggestions = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final response = await widget.places.searchByText(query);

    setState(() {
      _searchResults = response.results;
      _showSuggestions = _searchResults.isNotEmpty;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: widget.hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
              suffixIcon: _isSearching
                  ? Container(
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.teal,
                      ),
                    )
                  : Icon(Icons.location_on, color: Colors.teal),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            onChanged: (value) {
              _searchPlaces(value);
            },
            onTap: () {
              setState(() {
                _showSuggestions = _searchResults.isNotEmpty;
              });
            },
          ),
        ),
        if (_showSuggestions)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 4),
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  title: Text(place.name,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    place.formattedAddress ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    _controller.text = place.name;
                    widget.onPlaceSelected(place.placeId, place.name);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Future<void> saveTransportDetails({
  required String pickupLocation,
  required String dropoffLocation,
  required List<String> stopLocations,
  required String distance,
  required String duration,
  required String vehicleType,
  required double totalAmount,
  required String paymentId,
  required String userId,
}) async {
  try {
    await FirebaseFirestore.instance.collection('transport_bookings').add({
      'userId': userId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'stopLocations': stopLocations,
      'distance': distance,
      'duration': duration,
      'vehicleType': vehicleType,
      'totalAmount': totalAmount,
      'paymentId': paymentId,
      'status': 'completed',
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error saving transport details: $e');
    throw e;
  }
}
