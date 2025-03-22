import 'package:ceylonsphere/Nearby_Services_Pages/models/place.dart';
import 'package:ceylonsphere/pages/Home_Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../services/places_service.dart';
import '../widgets/category_button.dart';
import '../widgets/distance_button.dart';
import '../utils/location_utils.dart';
import '../constants/api_constants.dart';

class NearbyServicesScreen extends StatefulWidget {
  const NearbyServicesScreen({super.key});

  @override
  State<NearbyServicesScreen> createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  final PlacesService _placesService = PlacesService();
  GoogleMapController? mapController;
  String selectedDistance = '5km';
  String selectedCategory = 'Restaurants';
  final Set<Marker> _markers = {};
  final List<Place> _places = [];
  bool _isLoading = false;
  LatLng? _currentLocation;
  String? _errorMessage;

  // Directions variables
  Set<Polyline> _polylines = {};
  LatLng? _destinationLocation;
  String _selectedTravelMode = 'driving';
  Map<String, dynamic>? _directionsInfo;
  bool _showDirections = false;

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
        _currentLocation = const LatLng(7.8731, 80.7718); // Default to Sri Lanka center
      });
      
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

  Future<void> _loadNearbyPlaces() async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
      _places.clear();
      _markers.clear();
    });

    try {
      final selectedDistanceMeters = double.parse(selectedDistance.replaceAll('km', '')) * 1000;

      final places = await _placesService.getNearbyPlaces(
        location: _currentLocation!,
        radius: selectedDistanceMeters,
        category: selectedCategory,
      );

      setState(() {
        _places.addAll(places);
        _updateMarkers();
      });
    } catch (e) {
      print('Error loading places: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load nearby places: $e'),
            duration: const Duration(seconds: 3),
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
            icon: LocationUtils.getMarkerIcon(place.category),
          ),
        );
      }
    });
  }

  List<Place> _getFilteredPlaces() {
    return _places.where((place) {
      if (selectedCategory != place.category) {
        return false;
      }

      final distance = LocationUtils.calculateDistance(_currentLocation!, place.location);
      final selectedDistanceKm = double.parse(selectedDistance.replaceAll('km', ''));
      return distance <= selectedDistanceKm;
    }).toList();
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

  Future<void> _getDirections(LatLng destination) async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
      _showDirections = true;
      _destinationLocation = destination;
    });

    try {
      final directionsData = await _placesService.getDirections(
        origin: _currentLocation!,
        destination: destination,
        travelMode: _selectedTravelMode,
      );

      setState(() {
        _directionsInfo = {
          'distance': directionsData['distance'],
          'duration': directionsData['duration'],
          'start_address': directionsData['start_address'],
          'end_address': directionsData['end_address'],
        };

        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            points: directionsData['polyline_points'] as List<LatLng>,
            width: 4,
          ),
        );

        mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: directionsData['bounds']['southwest'] as LatLng,
              northeast: directionsData['bounds']['northeast'] as LatLng,
            ),
            50,
          ),
        );
      });
    } catch (e) {
      print('Error loading directions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load directions: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearDirections() {
    setState(() {
      _showDirections = false;
      _polylines.clear();
      _directionsInfo = null;
      _destinationLocation = null;
    });
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
                          LocationUtils.getCategoryIcon(place.category),
                          color: LocationUtils.getCategoryColor(place.category),
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
                          Navigator.pop(context);
                          _getDirections(place.location);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _currentLocation == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Getting your location...'),
            ],
          ),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Places'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate directly to the HomePage
            Navigator.pushReplacement(
            context,
            MaterialPageRoute( // Use MaterialPageRoute if your HomePage is Material-based
            builder: (context) => TravelApp(), // Replace HomePage() with your actual HomePage widget
                ),
              );
            },
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
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? const LatLng(7.2906, 80.6337),
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
          ),
          if (!_showDirections) ...[
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          CategoryButton(
                            title: 'Tourist Spots',
                            isSelected: selectedCategory == 'Tourist Spots',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Tourist Spots';
                                _updateMarkers();
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          CategoryButton(
                            title: 'Restaurants',
                            isSelected: selectedCategory == 'Restaurants',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Restaurants';
                                _updateMarkers();
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          CategoryButton(
                            title: 'Hotels',
                            isSelected: selectedCategory == 'Hotels',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Hotels';
                                _updateMarkers();
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          CategoryButton(
                            title: 'Shopping',
                            isSelected: selectedCategory == 'Shopping',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Shopping';
                                _updateMarkers();
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          CategoryButton(
                            title: 'Grocery',
                            isSelected: selectedCategory == 'Grocery',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Grocery';
                                _updateMarkers();
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          CategoryButton(
                            title: 'Liquor Stores',
                            isSelected: selectedCategory == 'Liquor Stores',
                            onTap: () {
                              setState(() {
                                selectedCategory = 'Liquor Stores';
                                _updateMarkers();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        DistanceButton(
                          distance: '2km',
                          isSelected: selectedDistance == '2km',
                          onTap: () {
                            setState(() {
                              selectedDistance = '2km';
                              _updateMarkers();
                            });
                          },
                        ),
                        DistanceButton(
                          distance: '5km',
                          isSelected: selectedDistance == '5km',
                          onTap: () {
                            setState(() {
                              selectedDistance = '5km';
                              _updateMarkers();
                            });
                          },
                        ),
                        DistanceButton(
                          distance: '10km',
                          isSelected: selectedDistance == '10km',
                          onTap: () {
                            setState(() {
                              selectedDistance = '10km';
                              _updateMarkers();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_showDirections && _directionsInfo != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _clearDirections,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _directionsInfo!['duration'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _directionsInfo!['distance'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTravelModeButton('driving', Icons.directions_car, 'Drive'),
                            _buildTravelModeButton('walking', Icons.directions_walk, 'Walk'),
                            _buildTravelModeButton('bicycling', Icons.directions_bike, 'Bike'),
                            _buildTravelModeButton('transit', Icons.directions_bus, 'Transit'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTravelModeButton(String mode, IconData icon, String label) {
    final isSelected = _selectedTravelMode == mode;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedTravelMode = mode;
          });
          if (_destinationLocation != null) {
            _getDirections(_destinationLocation!);
          }
        },
      ),
    );
  }
} 
