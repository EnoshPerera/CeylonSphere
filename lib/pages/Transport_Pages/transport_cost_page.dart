import 'package:flutter/material.dart';
import 'dart:math';

class TransportCostPage extends StatefulWidget {
  final String vehicleType;
  final String vehicleModel;
  final int passengerCount;
  final String distance;
  final String duration;
  final int plannedDays;
  final String pickupLocation;
  final String dropoffLocation;
  final List<String> stopLocations;

  const TransportCostPage({
    Key? key,
    required this.vehicleType,
    required this.vehicleModel,
    required this.passengerCount,
    required this.distance,
    required this.duration,
    required this.plannedDays,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.stopLocations, required DateTime pickupDate, required TimeOfDay pickupTime,
  }) : super(key: key);

  @override
  _TransportCostPageState createState() => _TransportCostPageState();
}

class _TransportCostPageState extends State<TransportCostPage> {
  late double _totalCostLKR;
  late double _totalCostUSD;
  late double _ratePerKm;
  late double _distanceValue;
  late double _dailyRate;
  late String _bookingReference;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _calculateCosts();
    _generateBookingReference();

    // Simulate processing
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _calculateCosts() {
    // Extract numerical distance value
    _distanceValue = double.parse(widget.distance.split(' ')[0]);

    // Set rate per km based on vehicle type
    switch (widget.vehicleType) {
      case 'Van':
        _ratePerKm = 150.0; // LKR per km for van
        _dailyRate = 3000.0; // LKR per day for van
        break;
      case 'Car':
        _ratePerKm = 120.0; // LKR per km for car
        _dailyRate = 2500.0; // LKR per day for car
        break;
      case 'Mini Bus':
        _ratePerKm = 200.0; // LKR per km for mini bus
        _dailyRate = 4000.0; // LKR per day for mini bus
        break;
      case 'Bus':
        _ratePerKm = 250.0; // LKR per km for bus
        _dailyRate = 5000.0; // LKR per day for bus
        break;
      default:
        _ratePerKm = 100.0; // Default rate
        _dailyRate = 2000.0; // Default daily rate
    }

    // Calculate base cost (distance * rate per km)
    double baseCost = _distanceValue * _ratePerKm;

    // Calculate cost per day
    double costPerDay = _dailyRate * widget.plannedDays;

    // Calculate total cost
    _totalCostLKR = baseCost + costPerDay;

    // Convert to USD (assuming 1 USD = 318 LKR as of March 2025)
    _totalCostUSD = _totalCostLKR / 318;
  }

  void _generateBookingReference() {
    // Generate a random booking reference
    final random = Random();
    String ref = 'TRV';
    for (int i = 0; i < 6; i++) {
      ref += random.nextInt(10).toString();
    }
    _bookingReference = ref;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Details',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
      body: _isProcessing
          ? _buildProcessingView()
          : _buildCostDetailsView(),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.teal,
          ),
          SizedBox(height: 20),
          Text(
            'Processing your booking...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostDetailsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSuccessHeader(),
          SizedBox(height: 24),
          _buildBookingReferenceCard(),
          SizedBox(height: 24),
          _buildCostBreakdownCard(),
          SizedBox(height: 24),
          _buildTripDetailsCard(),
          SizedBox(height: 24),
          _buildTermsAndConditionsCard(),
          SizedBox(height: 24),
          _buildConfirmButton(),
          SizedBox(height: 16),
          _buildHomeButton(),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 16),
          Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your vehicle has been successfully booked',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingReferenceCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Reference',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                _bookingReference,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.teal),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reference copied to clipboard!'))
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdownCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildCostRow('Distance', widget.distance),
            _buildCostRow('Rate per km', '${_ratePerKm.toStringAsFixed(2)} LKR'),
            _buildCostRow('Base Cost', '${(_distanceValue * _ratePerKm).toStringAsFixed(2)} LKR'),
            _buildCostRow('Cost per Day', '${_dailyRate.toStringAsFixed(2)} LKR'),
            _buildCostRow('Number of Days', '${widget.plannedDays}'),
            _buildCostRow('Total Cost per Day', '${(_dailyRate * widget.plannedDays).toStringAsFixed(2)} LKR'),
            Divider(thickness: 1.5),
            _buildCostRow('Total Cost (LKR)', '${_totalCostLKR.toStringAsFixed(2)} LKR', isTotal: true),
            _buildCostRow('Total Cost (USD)', '\$${_totalCostUSD.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.teal : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.teal : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Vehicle', '${widget.vehicleType} - ${widget.vehicleModel}'),
            _buildDetailRow('Passengers', '${widget.passengerCount}'),
            _buildDetailRow('Duration', '${widget.duration}'),
            _buildDetailRow('Planned Days', '${widget.plannedDays}'),
            _buildDetailRow('Pickup', '${widget.pickupLocation}'),
            if (widget.stopLocations.isNotEmpty)
              _buildDetailRow('Stops', '${widget.stopLocations.join(", ")}'),
            _buildDetailRow('Dropoff', '${widget.dropoffLocation}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildTermItem('Additional kilometers will be charged at the rate of ${_ratePerKm.toStringAsFixed(2)} LKR per km.'),
            _buildTermItem('Additional days will be charged at the rate of ${_dailyRate.toStringAsFixed(2)} LKR per day.'),
            _buildTermItem('Fuel is included in the price. Tolls and parking fees are not included and will be charged separately.'),
            _buildTermItem('A 50% deposit is required to confirm the booking.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.teal),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Booking Confirmed'),
              content: Text('Your booking has been confirmed. You will receive a confirmation email shortly.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Complete Booking',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildHomeButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.teal),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Text(
        'Back to Home',
        style: TextStyle(
          fontSize: 16,
          color: Colors.teal,
        ),
      ),
    );
  }
}

