import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PickupLocationMap extends StatefulWidget {
  final LatLng initialPosition;
  final Function(String) onLocationSelected;

  const PickupLocationMap({
    required this.initialPosition,
    required this.onLocationSelected,
  });

  @override
  _PickupLocationMapState createState() => _PickupLocationMapState();
}

class _PickupLocationMapState extends State<PickupLocationMap> {
  late GoogleMapController _mapController;
  late LatLng _selectedPosition;
  final String _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key
  late GoogleMapsPlaces _places;
  final TextEditingController _searchController = TextEditingController();

  final LatLngBounds _sriLankaBounds = LatLngBounds(
    southwest: LatLng(5.9, 79.9),
    northeast: LatLng(9.8, 81.9),
  );

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;
    _places = GoogleMapsPlaces(apiKey: _apiKey);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _moveToLocation(LatLng location) async {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(location, 14),
    );
    setState(() {
      _selectedPosition = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Pickup Location", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF003734),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TypeAheadField<Prediction>(
              suggestionsCallback: (pattern) async {
                if (pattern.isNotEmpty) {
                  final response = await _places.autocomplete(
                    pattern,
                    location: Location(lat: _selectedPosition.latitude, lng: _selectedPosition.longitude),
                    radius: 50000,
                    region: 'lk',
                  );
                  return response.predictions;
                }
                return [];
              },
              itemBuilder: (context, Prediction suggestion) {
                return ListTile(
                  title: Text(suggestion.description ?? ''),
                );
              },
              onSuggestionSelected: (Prediction suggestion) async {
                final details = await _places.getDetailsByPlaceId(suggestion.placeId ?? '');
                if (details.status == "OK") {
                  final location = details.result.geometry?.location;
                  if (location != null) {
                    final latLng = LatLng(location.lat, location.lng);
                    _moveToLocation(latLng);
                  }
                }
              },
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for a location...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 12,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              cameraTargetBounds: CameraTargetBounds(_sriLankaBounds),
              markers: {
                Marker(
                  markerId: MarkerId("pickup_location"),
                  position: _selectedPosition,
                  draggable: true,
                  onDragEnd: (LatLng newPosition) {
                    setState(() {
                      _selectedPosition = newPosition;
                    });
                  },
                ),
              },
              onTap: (position) {
                setState(() {
                  _selectedPosition = position;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Pickup Location:"),
                Text("Latitude: ${_selectedPosition.latitude}"),
                Text("Longitude: ${_selectedPosition.longitude}"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    widget.onLocationSelected(
                      'Lat: ${_selectedPosition.latitude}, Lng: ${_selectedPosition.longitude}',
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Confirm Location"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
