import 'package:flutter/material.dart';
import 'transport_final_page.dart';

class VehicleSelectionPage extends StatefulWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;
  final String distance;
  final String duration;

  const VehicleSelectionPage({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations,
    required this.distance,
    required this.duration,
  }) : super(key: key);

  @override
  _VehicleSelectionPageState createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  int passengerCount = 1;
  String recommendedVehicle = "Car";
  String? selectedVehicle;

  final List<VehicleOption> vehicleOptions = [
    VehicleOption(
      name: "Car",
      icon: Icons.directions_car,
      maxPassengers: 4,
      description: "Comfortable for small groups",
    ),
    VehicleOption(
      name: "Van",
      icon: Icons.airport_shuttle,
      maxPassengers: 8,
      description: "Perfect for medium groups",
    ),
    VehicleOption(
      name: "Mini Bus",
      icon: Icons.directions_bus,
      maxPassengers: 16,
      description: "Ideal for larger groups",
    ),
    VehicleOption(
      name: "Bus",
      icon: Icons.directions_bus,
      maxPassengers: 40,
      description: "Best for very large groups",
    ),
  ];

  void updateRecommendedVehicle(int count) {
    setState(() {
      passengerCount = count;
      if (count <= 4) {
        recommendedVehicle = "Car";
      } else if (count <= 8) {
        recommendedVehicle = "Van";
      } else if (count <= 16) {
        recommendedVehicle = "Mini Bus";
      } else {
        recommendedVehicle = "Bus";
      }

      // Auto-select the recommended vehicle
      selectedVehicle = recommendedVehicle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Vehicle', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip summary
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('From: ${widget.pickupLocation}'),
                  if (widget.stopLocations.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text('Stops: ${widget.stopLocations.join(", ")}'),
                  ],
                  SizedBox(height: 4),
                  Text('To: ${widget.dropoffLocation}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.route, size: 16, color: Colors.teal),
                      SizedBox(width: 4),
                      Text('Distance: ${widget.distance}'),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.teal),
                      SizedBox(width: 4),
                      Text('Duration: ${widget.duration}'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            Text('Number of Passengers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            // Passenger count input
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Passengers',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              onChanged: (value) {
                int? count = int.tryParse(value);
                if (count != null && count > 0) {
                  updateRecommendedVehicle(count);
                }
              },
            ),

            SizedBox(height: 24),
            Text('Recommended Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            // Vehicle recommendation
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    getVehicleIcon(recommendedVehicle),
                    size: 48,
                    color: Colors.teal,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recommendedVehicle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Best for $passengerCount ${passengerCount == 1 ? "passenger" : "passengers"}'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            Text('Available Vehicles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            // Vehicle options
            Expanded(
              child: ListView.builder(
                itemCount: vehicleOptions.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicleOptions[index];
                  final isSelected = selectedVehicle == vehicle.name;
                  final isRecommended = recommendedVehicle == vehicle.name;

                  return Card(
                    elevation: isSelected ? 4 : 1,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Colors.teal : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedVehicle = vehicle.name;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              vehicle.icon,
                              size: 40,
                              color: isSelected ? Colors.teal : Colors.grey[600],
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        vehicle.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? Colors.teal : Colors.black,
                                        ),
                                      ),
                                      if (isRecommended) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.teal.withOpacity(0.3)),
                                          ),
                                          child: Text(
                                            'Recommended',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    vehicle.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Up to ${vehicle.maxPassengers} passengers',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: vehicle.name,
                              groupValue: selectedVehicle,
                              onChanged: (value) {
                                setState(() {
                                  selectedVehicle = value;
                                });
                              },
                              activeColor: Colors.teal,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Navigate directly to the AvailableVehiclesPage from transport_final_page.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailableVehiclesPage(
                        vehicleType: selectedVehicle ?? recommendedVehicle,
                        passengerCount: passengerCount,
                        distance: widget.distance,
                        duration: widget.duration,
                        pickupLocation: widget.pickupLocation,
                        dropoffLocation: widget.dropoffLocation,
                        stopLocations: widget.stopLocations,
                        vehicleModel: "", // Pass empty string as default
                        plannedDays: 1, // Pass 1 as default planned days
                      ),
                    ),
                  );
                },
                child: Text('Confirm Vehicle', style: TextStyle(fontSize: 16, color: Colors.white) ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getVehicleIcon(String vehicle) {
    switch (vehicle) {
      case 'Car':
        return Icons.directions_car;
      case 'Van':
        return Icons.airport_shuttle;
      case 'Mini Bus':
        return Icons.directions_bus;
      case 'Bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }
}

class VehicleOption {
  final String name;
  final IconData icon;
  final int maxPassengers;
  final String description;

  VehicleOption({
    required this.name,
    required this.icon,
    required this.maxPassengers,
    required this.description,
  });
}