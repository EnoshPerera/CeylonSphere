import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;

// Google Places API key
const String apiKey = 'AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CeylonSphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const NearbyServicesPage(),
    );
  }
}

class Place {
  final String id;
  final String name;
  final String category;
  final LatLng location;
  final String description;
  final double rating;
  final double distance;
  final String address;
  final String photoReference;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.rating,
    this.distance = 0,
    required this.address,
    this.photoReference = '',
  });

  factory Place.fromGooglePlace(Map<String, dynamic> place, String category) {
    final location = place['geometry']['location'];
    return Place(
      id: place['place_id'],
      name: place['name'],
      category: category,
      location: LatLng(location['lat'], location['lng']),
      description: place['vicinity'] ?? '',
      rating: (place['rating'] ?? 0.0).toDouble(),
      address: place['vicinity'] ?? '',
      photoReference: place['photos']?[0]?['photo_reference'] ?? '',
    );
  }
}

class NearbyServicesPage extends StatefulWidget {
  const NearbyServicesPage({super.key});

  @override
  State<NearbyServicesPage> createState() => _NearbyServicesPageState();
}

class _NearbyServicesPageState extends State<NearbyServicesPage> {
  GoogleMapController? mapController;
  String selectedDistance = '5km';
  String selectedCategory = 'Restaurants';
  final Set<Marker> _markers = {};
  final List<Place> _places = [];
  bool _isLoading = false;
  LatLng? _currentLocation;
  String? _errorMessage;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable location services in your device settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied. Please enable location permissions in your app settings.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable location permissions in your device settings.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Load nearby places once we have the location
      await _loadNearbyPlaces();

      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 14),
        );
      }
    } catch (e) {
      print('Location error: $e');
      setState(() {
        _errorMessage = e.toString();
        // Use a default location (center of Sri Lanka) if location access fails
        _currentLocation = const LatLng(7.8731, 80.7718);
      });
      
      // Try to load places even with default location
      await _loadNearbyPlaces();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Failed to get location'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _getCurrentLocation,
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      final filteredPlaces = _getFilteredPlaces();
      
      for (var place in filteredPlaces) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.id),
            position: place.location,
            infoWindow: InfoWindow(
              title: place.name,
              snippet: '${place.rating.toStringAsFixed(1)}★ - ${place.address}',
            ),
            icon: _getMarkerIcon(place.category),
          ),
        );
      }
    });
  }

  BitmapDescriptor _getMarkerIcon(String category) {
    switch (category) {
      case 'Tourist Spots':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Restaurants':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      case 'Hotels':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'Shopping':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  List<Place> _getFilteredPlaces() {
    return _places.where((place) {
      if (selectedCategory != place.category) {
        return false;
      }

      final distance = _calculateDistance(place.location);
      final selectedDistanceKm = double.parse(selectedDistance.replaceAll('km', ''));
      return distance <= selectedDistanceKm;
    }).toList();
  }

  double _calculateDistance(LatLng location) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final lat1 = _currentLocation!.latitude * math.pi / 180;
    final lat2 = location.latitude * math.pi / 180;
    final dLat = (location.latitude - _currentLocation!.latitude) * math.pi / 180;
    final dLon = (location.longitude - _currentLocation!.longitude) * math.pi / 180;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLocation != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14),
      );
      _loadNearbyPlaces();
    }
  }

  Future<void> _loadNearbyPlaces() async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
      _places.clear();
      _markers.clear();
    });

    try {
      final selectedDistanceMeters = double.parse(selectedDistance.replaceAll('km', '')) * 1000;
      
      String placeType;
      switch (selectedCategory) {
        case 'Restaurants':
          placeType = 'restaurant';
          break;
        case 'Hotels':
          placeType = 'lodging';
          break;
        case 'Shopping':
          placeType = 'shopping_mall';
          break;
        case 'Tourist Spots':
          placeType = 'tourist_attraction';
          break;
        default:
          placeType = 'point_of_interest';
      }

      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '${_currentLocation!.latitude},${_currentLocation!.longitude}',
          'radius': selectedDistanceMeters.toString(),
          'type': placeType,
          'key': apiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        final results = response.data['results'] as List;
        for (var place in results) {
          final newPlace = Place.fromGooglePlace(place, selectedCategory);
          _places.add(newPlace);
        }
        _updateMarkers();
      } else {
        throw Exception('Failed to load places: ${response.data['status']}');
      }
    } catch (e) {
      print('Error loading places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load nearby places: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _refreshPlaces() {
    _loadNearbyPlaces();
  }

  void _showPlacesList() {
    final filteredPlaces = _getFilteredPlaces();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${selectedCategory} within ${selectedDistance}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${filteredPlaces.length} places found',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      return ListTile(
                        leading: Icon(
                          _getCategoryIcon(place.category),
                          color: _getCategoryColor(place.category),
                        ),
                        title: Text(place.name),
                        subtitle: Text(place.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              place.rating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () {
                          mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(place.location, 16),
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tourist Spots':
        return Icons.photo_camera;
      case 'Restaurants':
        return Icons.restaurant;
      case 'Hotels':
        return Icons.hotel;
      case 'Shopping':
        return Icons.shopping_cart;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Tourist Spots':
        return Colors.green;
      case 'Restaurants':
        return Colors.pink;
      case 'Hotels':
        return Colors.blue;
      case 'Shopping':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Places'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNearbyPlaces,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _currentLocation == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    if (_errorMessage != null && _currentLocation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentLocation ?? const LatLng(7.2906, 80.6337),
            zoom: 14.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              // Category buttons
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryButton('Tourist Spots', Icons.photo_camera, Colors.green),
                    _buildCategoryButton('Restaurants', Icons.restaurant, Colors.pink),
                    _buildCategoryButton('Hotels', Icons.hotel, Colors.blue),
                    _buildCategoryButton('Shopping', Icons.shopping_cart, Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Distance filter
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDistanceButton('2km'),
                    _buildDistanceButton('5km'),
                    _buildDistanceButton('10km'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // View Places button at bottom
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _showPlacesList,
            child: Text(
              'View Places (${_getFilteredPlaces().length})',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String title, IconData icon, Color color) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
          _updateMarkers();
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceButton(String distance) {
    bool isSelected = selectedDistance == distance;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDistance = distance;
          _updateMarkers();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          distance,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
