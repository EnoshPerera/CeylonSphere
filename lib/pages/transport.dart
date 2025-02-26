import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart';

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

  List<TextEditingController> _additionalStopsControllers = [];
  List<String> _placePredictions = [];
  final _places = GoogleMapsPlaces(apiKey: 'AIzaSyCwK3j_QlSn_wMDp4CAHN7A2Vhm-BbLei4');

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

  void _addStop() {
    setState(() {
      _additionalStopsControllers.add(TextEditingController());
    });
  }

  void _removeStop(int index) {
    setState(() {
      _additionalStopsControllers.removeAt(index);
    });
  }

  Future<void> _getPlacePredictions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placePredictions = [];
      });
      return;
    }

    try {
      final predictions = await _places.autocomplete(input, region: 'lk');
      setState(() {
        _placePredictions = predictions.predictions.map((p) => p.description ?? '').toList();
      });
    } catch (e) {
      print('Error fetching place predictions: $e');
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentStep >= 0 ? Color(0xFF003734) : Colors.grey,
            ),
            child: Center(
              child: Text(
                '1',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 20,
            height: 2,
            color: _currentStep > 0 ? Color(0xFF003734) : Colors.grey,
          ),
          SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentStep >= 1 ? Color(0xFF003734) : Colors.grey,
            ),
            child: Center(
              child: Text(
                '2',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 20,
            height: 2,
            color: _currentStep > 1 ? Color(0xFF003734) : Colors.grey,
          ),
          SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentStep >= 2 ? Color(0xFF003734) : Colors.grey,
            ),
            child: Center(
              child: Text(
                '3',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 20,
            height: 2,
            color: _currentStep > 2 ? Color(0xFF003734) : Colors.grey,
          ),
          SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentStep >= 3 ? Color(0xFF003734) : Colors.grey,
            ),
            child: Center(
              child: Text(
                '4',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailsForm() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildDatePicker('Pickup Date', _pickupDateController),
        _buildTimePicker('Pickup Time', _pickupTimeController),
        _buildLocationField('Pickup Location', _pickupLocationController),

        Center(
          child: InkWell(
            onTap: _addStop,
            child: Text(
              '+ Add Stop',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF003734),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        ..._additionalStopsControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return _buildStopInputField(controller, index);
        }).toList(),

        _buildLocationField('Drop-Off Location', _dropOffLocationController),
        _buildDropdown('Transfer Type', ['One Way', 'Round Trip'], (value) {
          setState(() {
            _transferType = value!;
          });
        }, _transferType),
      ],
    );
  }

  Widget _buildLocationField(String label, TextEditingController controller) {
    return Column(
      children: [
        _buildTextField(label, controller, onChanged: _getPlacePredictions),
        ..._placePredictions.map((prediction) => ListTile(
          title: Text(prediction),
          onTap: () {
            setState(() {
              controller.text = prediction;
              _placePredictions = [];
            });
          },
        )).toList(),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Color(0xFF003734)),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStopInputField(TextEditingController controller, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Stop Location',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Color(0xFF003734)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a stop location';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Color(0xFF003734)),
            onPressed: () => _removeStop(index),
          ),
        ],
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
      ),
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Color(0xFF003734)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectTime(context),
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Color(0xFF003734)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}