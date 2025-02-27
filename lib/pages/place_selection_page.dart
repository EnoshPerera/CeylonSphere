import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PlaceSelectionPage extends StatefulWidget {
  final GoogleMapsPlaces places;

  PlaceSelectionPage({required this.places});

  @override
  _PlaceSelectionPageState createState() => _PlaceSelectionPageState();
}

class _PlaceSelectionPageState extends State<PlaceSelectionPage> {
  final _searchController = TextEditingController();
  List<Prediction> _placePredictions = [];

  Future<void> _getPlacePredictions(String input) async {
    if (input.isEmpty) {
      setState(() => _placePredictions = []);
      return;
    }
    final predictions = await widget.places.autocomplete(input, region: 'lk');
    setState(() => _placePredictions = predictions.predictions);
  }

  void _selectPlace(Prediction prediction) {
    Navigator.pop(context, {
      'placeId': prediction.placeId,
      'name': prediction.description,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Location')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a place',
                border: OutlineInputBorder(),
              ),
              onChanged: _getPlacePredictions,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _placePredictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placePredictions[index].description ?? ''),
                  onTap: () => _selectPlace(_placePredictions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
