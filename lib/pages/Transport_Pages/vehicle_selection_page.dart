import 'package:flutter/material.dart';
import 'transport_final_page.dart';

class VehicleSelectionPage extends StatefulWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;
  final String distance;
  final String duration;
  final Function(
          String vehicleType, double amount, String paymentId, String userId)
      onPaymentSuccess;

  const VehicleSelectionPage({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations,
    required this.distance,
    required this.duration,
    required this.onPaymentSuccess,
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
        description: "Comfortable for small groups"),
    VehicleOption(
        name: "Van",
        icon: Icons.airport_shuttle,
        maxPassengers: 8,
        description: "Perfect for medium groups"),
    VehicleOption(
        name: "Mini Bus",
        icon: Icons.directions_bus,
        maxPassengers: 16,
        description: "Ideal for larger groups"),
    VehicleOption(
        name: "Bus",
        icon: Icons.directions_bus,
        maxPassengers: 40,
        description: "Best for very large groups"),
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
      selectedVehicle = recommendedVehicle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside the TextField
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Vehicle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: 16,
              bottom: 100, // Add extra padding at the bottom
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTripSummary(),
                SizedBox(height: 16),
                _buildPassengerInput(),
                SizedBox(height: 16),
                _buildRecommendedVehicle(),
                SizedBox(height: 16),
                _buildAvailableVehicles(),
                SizedBox(height: 16),
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    );
  }

  Widget _buildPassengerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Number of Passengers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
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
      ],
    );
  }

  Widget _buildRecommendedVehicle() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(getVehicleIcon(recommendedVehicle),
              size: 48, color: Colors.teal),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recommendedVehicle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                  'Best for $passengerCount ${passengerCount == 1 ? "passenger" : "passengers"}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableVehicles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available Vehicles',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Column(
          children: vehicleOptions.map((vehicle) {
            final isSelected = selectedVehicle == vehicle.name;
            final isRecommended = recommendedVehicle == vehicle.name;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: isSelected ? Colors.teal : Colors.transparent,
                    width: 2),
              ),
              child: ListTile(
                leading: Icon(vehicle.icon,
                    size: 40,
                    color: isSelected ? Colors.teal : Colors.grey[600]),
                title: Text(vehicle.name,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${vehicle.description} - Up to ${vehicle.maxPassengers} passengers'),
                trailing: Radio<String>(
                  value: vehicle.name,
                  groupValue: selectedVehicle,
                  onChanged: (value) => setState(() => selectedVehicle = value),
                  activeColor: Colors.teal,
                ),
                onTap: () => setState(() => selectedVehicle = vehicle.name),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, minimumSize: Size(double.infinity, 50)),
      onPressed: () {
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
              vehicleModel: "",
              plannedDays: 1,
              onPaymentSuccess: widget.onPaymentSuccess,
            ),
          ),
        );
      },
      child: Text('Confirm Vehicle',
          style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  IconData getVehicleIcon(String vehicle) {
    switch (vehicle) {
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

  VehicleOption(
      {required this.name,
      required this.icon,
      required this.maxPassengers,
      required this.description});
}
