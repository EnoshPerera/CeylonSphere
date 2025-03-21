import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition =
      const LatLng(6.9271, 79.8612); // Colombo, Sri Lanka
  final Set<Marker> _markers = {};
  double _radiusInMeters = 5000; // Default: 5km
  String _selectedPlaceType = 'tourist_attraction';
  String apiKey = "AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA";
  bool _isLoading = false;

  final Map<String, Map<String, dynamic>> _placeTypes = {
    'tourist_attraction': {
      'label': 'Tourist Spots',
      'icon': CupertinoIcons.camera,
      'color': Color(0xFF4CAF50),
    },
    'restaurant': {
      'label': 'Restaurants',
      'icon': CupertinoIcons.circle_grid_3x3,
      'color': Color(0xFFE91E63),
    },
    'hotel': {
      'label': 'Hotels',
      'icon': CupertinoIcons.bed_double,
      'color': Color(0xFF2196F3),
    },
    'shopping_mall': {
      'label': 'Shopping',
      'icon': CupertinoIcons.cart,
      'color': Color(0xFF9C27B0),
    },
    'park': {
      'label': 'Parks',
      'icon': CupertinoIcons.tree,
      'color': Color(0xFF8BC34A),
    },
    'museum': {
      'label': 'Museums',
      'icon': CupertinoIcons.building_2_fill,
      'color': Color(0xFF795548),
    },
    'temple': {
      'label': 'Temples',
      'icon': CupertinoIcons.heart,
      'color': Color(0xFFFF9800),
    },
    'beach': {
      'label': 'Beaches',
      'icon': CupertinoIcons.sunrise,
      'color': Color(0xFF00BCD4),
    },
    'bar': {
      'label': 'Bars & Wine',
      'icon': CupertinoIcons.circle_grid_3x3,
      'color': Color(0xFF9C27B0),
      'types': ['bar', 'liquor_store'],
    },
  };

  List<Map<String, dynamic>> _places = [];
  bool _isBottomSheetVisible = false;

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
    setState(() {
      _isLoading = true;
      _markers.clear();
      _places.clear();
    });

    String typeParam = _selectedPlaceType;
    if (_selectedPlaceType == 'bar') {
      typeParam = 'bar|liquor_store';
    }

    final url =
        Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json"
            "?location=${location.latitude},${location.longitude}"
            "&radius=$_radiusInMeters"
            "&type=$typeParam"
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
          _places = List<Map<String, dynamic>>.from(results);
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
                  onTap: () {
                    _showPlaceDetails(place);
                  },
                ),
              ),
            );
          }
          _isLoading = false;
        });
      } else {
        print("API Request Failed: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching places: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openDirections(Map<String, dynamic> place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final name = Uri.encodeComponent(place['name']);

    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_name=$name');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('Could not open directions'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place["name"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              place["vicinity"],
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.systemGrey.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            if (place["rating"] != null) ...[
              Row(
                children: [
                  Icon(
                    CupertinoIcons.star_fill,
                    color: CupertinoColors.systemYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    place["rating"].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (place["opening_hours"] != null) ...[
              Text(
                place["opening_hours"]["open_now"] ? "Open Now" : "Closed",
                style: TextStyle(
                  fontSize: 16,
                  color: place["opening_hours"]["open_now"]
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemRed,
                ),
              ),
            ],
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: () => _openDirections(place),
              child: const Text('Get Directions'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlacesBottomSheet() {
    setState(() {
      _isBottomSheetVisible = true;
    });

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Places',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.xmark),
                    onPressed: () {
                      setState(() {
                        _isBottomSheetVisible = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  final place = _places[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(
                                place['geometry']['location']['lat'],
                                place['geometry']['location']['lng'],
                              ),
                              15,
                            ),
                          );
                          _openDirections(place);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _placeTypes[_selectedPlaceType]![
                                              'color']
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _placeTypes[_selectedPlaceType]!['icon'],
                                      color: _placeTypes[_selectedPlaceType]![
                                          'color'],
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place['name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          place['vicinity'],
                                          style: TextStyle(
                                            color: CupertinoColors.systemGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (place['rating'] != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGreen
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.star_fill,
                                            color: CupertinoColors.systemGreen,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            place['rating'].toString(),
                                            style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              if (place['opening_hours'] != null) ...[
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.clock,
                                      size: 16,
                                      color: place['opening_hours']['open_now']
                                          ? CupertinoColors.systemGreen
                                          : CupertinoColors.systemRed,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      place['opening_hours']['open_now']
                                          ? 'Open Now'
                                          : 'Closed',
                                      style: TextStyle(
                                        color: place['opening_hours']
                                                ['open_now']
                                            ? CupertinoColors.systemGreen
                                            : CupertinoColors.systemRed,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Find Places'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh),
          onPressed: () => _getUserLocation(),
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
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
          ),

          // Place Type Selector
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _placeTypes.entries.map((entry) {
                  final isSelected = _selectedPlaceType == entry.key;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlaceType = entry.key;
                        _fetchNearbyPlaces(_initialPosition);
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? entry.value['color']
                            : CupertinoColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            entry.value['icon'],
                            color: isSelected
                                ? CupertinoColors.white
                                : entry.value['color'],
                            size: 28,
                          ),
                          SizedBox(height: 8),
                          Text(
                            entry.value['label'],
                            style: TextStyle(
                              color: isSelected
                                  ? CupertinoColors.white
                                  : CupertinoColors.systemGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Radius Selector
          Positioned(
            top: 230,
            left: 20,
            right: 20,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CupertinoSlidingSegmentedControl<double>(
                groupValue: _radiusInMeters,
                children: {
                  2000.0: const Text("2km"),
                  5000.0: const Text("5km"),
                  10000.0: const Text("10km"),
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
          ),

          // Places List Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CupertinoButton.filled(
              onPressed: _showPlacesBottomSheet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.list_bullet),
                  SizedBox(width: 8),
                  Text('View Places (${_places.length})'),
                ],
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            const Positioned(
              top: 280,
              left: 0,
              right: 0,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
