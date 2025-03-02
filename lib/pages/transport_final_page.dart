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
    // Generate a random booking reference
    final String bookingRef = 'TR${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 13)}';

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Trip Ticket'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Ticket Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TRAVEL TICKET',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Booking Ref: $bookingRef',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.directions_car_filled,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Ticket Divider with circles
              Container(
                height: 30,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 15).floor(),
                                  (index) => SizedBox(
                                width: 5,
                                height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ticket Content
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Route Section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FROM',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                pickupLocation,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.teal,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'TO',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                dropoffLocation,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Trip Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailColumn('VEHICLE', '$vehicleType\n$vehicleModel'),
                        _buildDetailColumn('PASSENGERS', passengerCount.toString()),
                        _buildDetailColumn('DURATION', duration),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailColumn('DISTANCE', distance),
                        _buildDetailColumn('DAYS', plannedDays.toString()),
                        _buildDetailColumn('TYPE', 'Air-Conditioned'),
                      ],
                    ),

                    if (stopLocations.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Divider(color: Colors.grey.withOpacity(0.3)),
                      SizedBox(height: 10),

                      // Stop Locations
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STOPS',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...stopLocations.map((stop) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.teal),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    stop,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Ticket Footer
              Container(
                height: 30,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 15).floor(),
                                  (index) => SizedBox(
                                width: 5,
                                height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Barcode Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Fake barcode
                    Container(
                      height: 70,
                      width: 200,
                      child: CustomPaint(
                        painter: BarcodePainter(),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      bookingRef,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Confirm Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Custom painter for barcode effect
class BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final random = DateTime.now().millisecondsSinceEpoch;

    // Draw random vertical lines to simulate barcode
    for (int i = 0; i < size.width; i += 4) {
      if ((i + random) % 3 == 0) {
        final height = (i % 7 == 0) ? size.height : size.height * 0.7;
        canvas.drawLine(
          Offset(i.toDouble(), 0),
          Offset(i.toDouble(), height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}