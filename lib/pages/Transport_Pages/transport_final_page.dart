import 'dart:ui';

import 'package:flutter/material.dart';
import 'transport_cost_page.dart';
import 'package:intl/intl.dart';

class AvailableVehiclesPage extends StatefulWidget {
  final String vehicleType;
  final int passengerCount;
  final String distance;
  final String duration;
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;
  final Function(
          String vehicleType, double amount, String paymentId, String userId)
      onPaymentSuccess;

  const AvailableVehiclesPage({
    super.key,
    required this.vehicleType,
    required this.passengerCount,
    required this.distance,
    required this.duration,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations,
    required this.onPaymentSuccess,
    required int plannedDays,
    required String vehicleModel,
  });

  @override
  _AvailableVehiclesPageState createState() => _AvailableVehiclesPageState();
}

class _AvailableVehiclesPageState extends State<AvailableVehiclesPage> {
  String? selectedVehicle;
  int plannedDays = 1;

  final Map<String, List<VehicleDetails>> vehicleOptions = {
    "Car": [
      VehicleDetails(
          brand: "Toyota",
          model: "Corolla",
          imageUrl: "assets/toyota-corolla.jpg",
          details: "5 seats, air-conditioned, fuel-efficient"),
      VehicleDetails(
          brand: "Honda",
          model: "Civic",
          imageUrl: "assets/Honda-Civic.jpeg",
          details: "5 seats, air-conditioned, comfortable ride"),
      VehicleDetails(
          brand: "Suzuki",
          model: "Swift",
          imageUrl: "assets/Suzuki-Swift.jpg",
          details: "5 seats, air-conditioned, compact"),
    ],
    "Van": [
      VehicleDetails(
          brand: "Toyota",
          model: "HiAce",
          imageUrl: "assets/toyota-hiace.jpg",
          details: "8 seats, air-conditioned, spacious"),
      VehicleDetails(
          brand: "Nissan",
          model: "Urvan",
          imageUrl: "assets/nissan-urvan.jpg",
          details: "8 seats, air-conditioned, comfortable"),
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
                onTap: () =>
                    Navigator.of(context).pop(), // Dismiss on tapping outside
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
        title: Text(
          'Available ${widget.vehicleType}s',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select an Air-Conditioned ${widget.vehicleType}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        onTap: () => _showImagePopup(context,
                            vehicle.imageUrl), // Show image popup on tap
                        child: SizedBox(
                          width: 100, // Set the width of the image
                          height: 60, // Set the height of the image
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.3), // Shadow color
                                    spreadRadius:
                                        2, // Spread radius of the shadow
                                    blurRadius: 4, // Blur radius of the shadow
                                    offset: Offset(0, 3), // Shadow position
                                  ),
                                ],
                              ),
                              child: Image.asset(vehicle.imageUrl,
                                  fit: BoxFit.cover), // Constrained image
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
            Text('Planned Trip Duration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
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
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Push button to the bottom
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 100), // 100 pixels from bottom
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: selectedVehicle == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripSummaryPage(
                                  vehicleType: widget.vehicleType,
                                  vehicleModel:
                                      selectedVehicle!, // pass vehicleModel
                                  passengerCount: widget.passengerCount,
                                  distance: widget.distance,
                                  duration: widget.duration,
                                  plannedDays: plannedDays, // pass plannedDays
                                  pickupLocation: widget.pickupLocation,
                                  dropoffLocation: widget.dropoffLocation,
                                  stopLocations: widget.stopLocations,
                                  onPaymentSuccess: widget.onPaymentSuccess,
                                ),
                              ),
                            );
                          },
                    child: Text(
                      'Proceed to Summary',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
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

class TripSummaryPage extends StatefulWidget {
  final String vehicleType;
  final String vehicleModel;
  final int passengerCount;
  final String distance;
  final String duration;
  final int plannedDays;
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;
  final Function(
          String vehicleType, double amount, String paymentId, String userId)
      onPaymentSuccess;

  const TripSummaryPage({
    super.key,
    required this.vehicleType,
    required this.vehicleModel,
    required this.passengerCount,
    required this.distance,
    required this.duration,
    required this.plannedDays,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations,
    required this.onPaymentSuccess,
  });

  @override
  _TripSummaryPageState createState() => _TripSummaryPageState();
}

class _TripSummaryPageState extends State<TripSummaryPage> {
  // Default pickup date as tomorrow
  DateTime pickupDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay pickupTime = TimeOfDay(hour: 9, minute: 0); // Default 9:00 AM

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickupDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // calendar text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != pickupDate) {
      setState(() {
        pickupDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: pickupTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // dial text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != pickupTime) {
      setState(() {
        pickupTime = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  String formatTime(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Trip Ticket',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
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
                                fontSize: isSmallScreen ? 18 : 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                widget.pickupLocation,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 14 : 16,
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
                                widget.dropoffLocation,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 14 : 16,
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

                    // Pickup Date and Time Section
                    Text(
                      'PICKUP DETAILS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Date Selector
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.teal),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                formatDate(pickupDate),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Time Selector
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.teal),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                formatTime(pickupTime),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Trip Details
                    Wrap(
                      spacing: isSmallScreen ? 10 : 20,
                      runSpacing: 15,
                      children: [
                        _buildDetailColumn(
                            'VEHICLE',
                            '${widget.vehicleType}\n${widget.vehicleModel}',
                            isSmallScreen),
                        _buildDetailColumn('PASSENGERS',
                            widget.passengerCount.toString(), isSmallScreen),
                        _buildDetailColumn(
                            'DURATION', widget.duration, isSmallScreen),
                      ],
                    ),

                    SizedBox(height: 20),

                    Wrap(
                      spacing: isSmallScreen ? 10 : 20,
                      runSpacing: 15,
                      children: [
                        _buildDetailColumn(
                            'DISTANCE', widget.distance, isSmallScreen),
                        _buildDetailColumn('DAYS',
                            widget.plannedDays.toString(), isSmallScreen),
                        _buildDetailColumn(
                            'TYPE', 'Air-Conditioned', isSmallScreen),
                      ],
                    ),

                    if (widget.stopLocations.isNotEmpty) ...[
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
                          ...widget.stopLocations
                              .map((stop) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 16, color: Colors.teal),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            stop,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              ,
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

              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Confirm Button
              Padding(
                padding: EdgeInsets.only(bottom: 100), // Adjust padding here
                child: ElevatedButton(
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
                          vehicleType: widget.vehicleType,
                          vehicleModel: widget.vehicleModel,
                          passengerCount: widget.passengerCount,
                          distance: widget.distance,
                          duration: widget.duration,
                          plannedDays: widget.plannedDays,
                          pickupLocation: widget.pickupLocation,
                          dropoffLocation: widget.dropoffLocation,
                          stopLocations: widget.stopLocations,
                          pickupDate: pickupDate,
                          pickupTime: pickupTime,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Confirm Booking',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, bool isSmallScreen) {
    return SizedBox(
      width: isSmallScreen ? 90 : 100,
      child: Column(
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
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}