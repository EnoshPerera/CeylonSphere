import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(TravelBookingApp());
}

class TravelBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BookingHomePage(),
    );
  }
}

class BookingHomePage extends StatefulWidget {
  @override
  _BookingHomePageState createState() => _BookingHomePageState();
}

class _BookingHomePageState extends State<BookingHomePage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _dropOffLocationController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _transferType = 'One Way';
  String _vehicleType = 'Sedan';

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
        _pageController.animateToPage(_currentStep,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(_currentStep,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        _pickupDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() {
        _pickupTimeController.text = picked.format(context);
      });
  }

  Future<void> _selectPickupLocation(BuildContext context) async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickupLocationMap(),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _pickupLocationController.text =
        'Lat: ${selectedLocation.latitude}, Lng: ${selectedLocation.longitude}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Trip', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF003734),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildTripDetailsForm(),
                  _buildVehicleSelection(),
                  _buildContactInfoForm(),
                  _buildBookingSummary(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return Column(
            children: [
              CircleAvatar(
                backgroundColor: index == _currentStep ? Color(0xFF003734) : Colors.grey,
                child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 4),
              Text(['Enter Details', 'Choose Vehicle', 'Contact Info', 'Summary'][index],
                  style: TextStyle(color: Color(0xFF003734))),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTripDetailsForm() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildDatePicker('Pickup Date', _pickupDateController),
        _buildTimePicker('Pickup Time', _pickupTimeController),
        _buildPickupLocationField(),
        _buildTextField('Drop-Off Location', _dropOffLocationController),
        _buildDropdown('Transfer Type', ['One Way', 'Round Trip'], (value) {
          setState(() {
            _transferType = value!;
          });
        }, _transferType),
      ],
    );
  }

  Widget _buildPickupLocationField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _selectPickupLocation(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: _pickupLocationController,
            decoration: InputDecoration(
              labelText: 'Pickup Location (Tap to select on map)',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Color(0xFF003734)),
              suffixIcon: Icon(Icons.location_on, color: Color(0xFF003734)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select Pickup Location';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Select Vehicle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003734))),
        SizedBox(height: 10),
        _buildDropdown('Vehicle Type', ['Sedan', 'SUV', 'Van', 'Luxury'], (value) {
          setState(() {
            _vehicleType = value!;
          });
        }, _vehicleType),
      ],
    );
  }

  Widget _buildContactInfoForm() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildTextField('Full Name', _fullNameController),
        _buildTextField('Email', _emailController),
        _buildTextField('Phone Number', _phoneNumberController),
      ],
    );
  }

  Widget _buildBookingSummary() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Booking Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003734))),
        SizedBox(height: 10),
        _buildSummaryItem('Pickup Date', _pickupDateController.text),
        _buildSummaryItem('Pickup Time', _pickupTimeController.text),
        _buildSummaryItem('Pickup Location', _pickupLocationController.text),
        _buildSummaryItem('Drop-Off Location', _dropOffLocationController.text),
        _buildSummaryItem('Transfer Type', _transferType),
        _buildSummaryItem('Vehicle Type', _vehicleType),
        _buildSummaryItem('Full Name', _fullNameController.text),
        _buildSummaryItem('Email', _emailController.text),
        _buildSummaryItem('Phone Number', _phoneNumberController.text),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentStep > 0
              ? ElevatedButton(
            onPressed: _previousStep,
            child: Text('Back', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003734)),
          )
              : SizedBox.shrink(),
          ElevatedButton(
            onPressed: _currentStep < 3 ? _nextStep : () {},
            child: Text(_currentStep < 3 ? 'Next' : 'Confirm Booking',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003734)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Color(0xFF003734)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Color(0xFF003734)),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Color(0xFF003734)),
          suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF003734)),
        ),
        onTap: () => _selectDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTimePicker(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Color(0xFF003734)),
          suffixIcon: Icon(Icons.access_time, color: Color(0xFF003734)),
        ),
        onTap: () => _selectTime(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003734))),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}

class PickupLocationMap extends StatefulWidget {
  @override
  _PickupLocationMapState createState() => _PickupLocationMapState();
}

class _PickupLocationMapState extends State<PickupLocationMap> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = LatLng(7.8731, 80.7718); // Center of Sri Lanka

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Pickup Location'),
        backgroundColor: Color(0xFF003734),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLocation,
          zoom: 7.5,
        ),
        onMapCreated: (controller) => _mapController = controller,
        markers: {
          Marker(
            markerId: MarkerId('selectedLocation'),
            position: _selectedLocation,
            draggable: true,
            onDragEnd: (newPosition) {
              setState(() => _selectedLocation = newPosition);
            },
          ),
        },
        onTap: (position) {
          setState(() => _selectedLocation = position);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        child: Icon(Icons.check, color: Colors.white),
        backgroundColor: Color(0xFF003734),
      ),
    );
  }
}
