import 'dart:ui';

import 'package:flutter/material.dart';
import 'transport_cost_page.dart';

class AvailableVehiclesPage extends StatefulWidget {
  final String vehicleType;
  final int passengerCount;
  final String distance;
  final String duration;
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;

  const AvailableVehiclesPage({
    Key? key,
    required this.vehicleType,
    required this.passengerCount,
    required this.distance,
    required this.duration,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations, required String vehicleModel, required int plannedDays,
  }) : super(key: key);

  @override
  _AvailableVehiclesPageState createState() => _AvailableVehiclesPageState();
}

class _AvailableVehiclesPageState extends State<AvailableVehiclesPage> {
  String? selectedVehicle;
  int plannedDays = 1;

  final Map<String, List<VehicleDetails>> vehicleOptions = {
    "Car": [
      VehicleDetails(brand: "Toyota", model: "Corolla", imageUrl: "assets/toyota-corolla.jpg", details: "5 seats, air-conditioned, fuel-efficient"),
      VehicleDetails(brand: "Honda", model: "Civic", imageUrl: "assets/Honda-Civic.jpeg", details: "5 seats, air-conditioned, comfortable ride"),
      VehicleDetails(brand: "Suzuki", model: "Swift", imageUrl: "assets/Suzuki-Swift.jpg", details: "5 seats, air-conditioned, compact"),
    ],
    "Van": [
      VehicleDetails(brand: "Toyota", model: "HiAce", imageUrl: "assets/toyota-hiace.jpg", details: "8 seats, air-conditioned, spacious"),
      VehicleDetails(brand: "Nissan", model: "Urvan", imageUrl: "assets/nissan-urvan.jpg", details: "8 seats, air-conditioned, comfortable"),
    ],
  };

  String getRecommendedDuration() {
    int hours = int.parse(widget.duration.split(' ')[0]);
    if (hours <= 8) {
      return "1 day";
    } else if (hours <= 16) {
      return "2 days";
    } else {
      return "${(hours / 8).ceil()} days";
    }
  }

  // Show image popup
  void _showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(), // Dismiss on tapping outside
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: double.infinity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Center(
                child: AnimatedScale(
                  scale: 1.0, // Control scale for zoom effect
                  duration: Duration(milliseconds: 300),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.contain,
                      height: 400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available ${widget.vehicleType}s'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select an Air-Conditioned ${widget.vehicleType}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: vehicleOptions[widget.vehicleType]?.length ?? 0,
                itemBuilder: (context, index) {
                  final vehicle = vehicleOptions[widget.vehicleType]![index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => _showImagePopup(context, vehicle.imageUrl), // Show image popup on tap
                        child: SizedBox(
                          width: 100,  // Set the width of the image
                          height: 60,  // Set the height of the image
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3), // Shadow color
                                    spreadRadius: 2, // Spread radius of the shadow
                                    blurRadius: 4, // Blur radius of the shadow
                                    offset: Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: Image.asset(vehicle.imageUrl, fit: BoxFit.cover),  // Constrained image
                            ),
                          ),
                        ),
                      ),
                      title: Text('${vehicle.brand} ${vehicle.model}'),
                      subtitle: Text(vehicle.details),
                      trailing: Radio<String>(
                        value: '${vehicle.brand} ${vehicle.model}',
                        groupValue: selectedVehicle,
                        onChanged: (value) {
                          setState(() {
                            selectedVehicle = value;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Planned Trip Duration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Days',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        plannedDays = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Text('Recommended: ${getRecommendedDuration()}'),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: selectedVehicle != null ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripSummaryPage(
                      vehicleType: widget.vehicleType,
                      vehicleModel: selectedVehicle!, // pass vehicleModel
                      passengerCount: widget.passengerCount,
                      distance: widget.distance,
                      duration: widget.duration,
                      plannedDays: plannedDays, // pass plannedDays
                      pickupLocation: widget.pickupLocation,
                      dropoffLocation: widget.dropoffLocation,
                      stopLocations: widget.stopLocations,
                    ),
                  ),
                );
              } : null,
              child: Text('Proceed to Summary', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleDetails {
  final String brand;
  final String model;
  final String imageUrl;
  final String details;

  VehicleDetails({
    required this.brand,
    required this.model,
    required this.imageUrl,
    required this.details,
  });
}

class TripSummaryPage extends StatelessWidget {
  final String vehicleType;
  final String vehicleModel;
  final int passengerCount;
  final String distance;
  final String duration;
  final int plannedDays;
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;

  const TripSummaryPage({
    Key? key,
    required this.vehicleType,
    required this.vehicleModel,
    required this.passengerCount,
    required this.distance,
    required this.duration,
    required this.plannedDays,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Summary'),
        backgroundColor: Colors.teal,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip Summary',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 16),
              _buildSummaryItem('Vehicle Type', '$vehicleType (Air-Conditioned)', isBold: true),
              _buildSummaryItem('Vehicle Model', vehicleModel),
              _buildSummaryItem('Passengers', passengerCount.toString()),
              _buildSummaryItem('Distance', distance),
              _buildSummaryItem('Estimated Duration', duration),
              _buildSummaryItem('Planned Days', plannedDays.toString()),
              _buildSummaryItem('Pickup Location', pickupLocation),
              _buildSummaryItem('Dropoff Location', dropoffLocation),
              _buildSummaryItem('Stop Locations', stopLocations.join(', ')),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Color for button
                  minimumSize: Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransportCostPage(
                        vehicleType: vehicleType,
                        vehicleModel: vehicleModel,
                        passengerCount: passengerCount,
                        distance: distance,
                        duration: duration,
                        plannedDays: plannedDays,
                        pickupLocation: pickupLocation,
                        dropoffLocation: dropoffLocation,
                        stopLocations: stopLocations,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
