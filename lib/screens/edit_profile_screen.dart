// import 'package:flutter/material.dart';

// class EditProfileScreen extends StatelessWidget {
//   const EditProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text(
//               "Edit Your Profile",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             // Add form fields or other UI elements to edit profile
//           ],
//         ),
//       ),
//     );
//   }
// }

// //2nd
// import 'package:flutter/material.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   String? _selectedGender = 'Male'; // Default gender selection

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.white, // Changed to white color
//         elevation: 0, // Optional: to remove the shadow beneath the AppBar
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Username
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your username';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Email
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zAZ0-9.-]+$").hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Phone number
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Gender selection
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 decoration: const InputDecoration(
//                   labelText: 'Gender',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['Male', 'Female', 'Other']
//                     .map((gender) => DropdownMenuItem<String>(
//                           value: gender,
//                           child: Text(gender),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedGender = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Save button
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Save the data or perform any logic here
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Profile Updated')),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF52B788), // Green color for button
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//3rd
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // Import the image_picker package
// import 'dart:io'; // To handle the picked image file

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   String? _selectedGender = 'Male'; // Default gender selection
//   File? _profileImage; // Variable to hold the selected image

//   // Function to pick an image from the gallery or camera
//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery, // You can change this to ImageSource.camera to take a photo
//     );

//     if (image != null) {
//       setState(() {
//         _profileImage = File(image.path); // Set the profile image to the picked image
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.white, // Changed to white color
//         elevation: 0, // Optional: to remove the shadow beneath the AppBar
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Profile Picture section
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage, // Allow the user to pick a new image on tap
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: _profileImage != null
//                         ? FileImage(_profileImage!) // Show the selected image
//                         : const AssetImage('assets/profile_picture.png') as ImageProvider,
//                     child: _profileImage == null // Show a camera icon if no image selected
//                         ? const Icon(Icons.camera_alt, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16.0),

//               // Username
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your username';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Email
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zAZ0-9.-]+$").hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Phone number
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Gender selection
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 decoration: const InputDecoration(
//                   labelText: 'Gender',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['Male', 'Female', 'Other']
//                     .map((gender) => DropdownMenuItem<String>(
//                           value: gender,
//                           child: Text(gender),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedGender = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),

//               // Save button
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Save the data or perform any logic here
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Profile Updated')),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF059669), // Green color for button
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//add cancel button
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedGender = 'Male';
  File? _profileImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/profile_picture.png') as ImageProvider,
                    child: _profileImage == null ? const Icon(Icons.camera_alt, color: Colors.white) : null,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zAZ0-9.-]+$").hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile Updated')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF059669)),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//back-end
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   String? _selectedGender = 'Male';
//   File? _profileImage;

//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _profileImage = File(image.path);
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
    
//     const String apiUrl = "https://your-api.com/update-profile"; // Replace with your actual API endpoint
    
//     try {
//       final response = await http.put(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': _usernameController.text,
//           'email': _emailController.text,
//           'phone': _phoneController.text,
//           'gender': _selectedGender,
//         }),
//       );
      
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile Updated Successfully')),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to update profile')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: _profileImage != null
//                         ? FileImage(_profileImage!)
//                         : const AssetImage('assets/profile_picture.png') as ImageProvider,
//                     child: _profileImage == null
//                         ? const Icon(Icons.camera_alt, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) => value!.isEmpty ? 'Enter a username' : null,
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) => !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zAZ0-9.-]+$").hasMatch(value!)
//                     ? 'Enter a valid email'
//                     : null,
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) => value!.isEmpty ? 'Enter a phone number' : null,
//               ),
//               const SizedBox(height: 16.0),
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 decoration: const InputDecoration(
//                   labelText: 'Gender',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['Male', 'Female', 'Other']
//                     .map((gender) => DropdownMenuItem<String>(
//                           value: gender,
//                           child: Text(gender),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedGender = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFF4C04E),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               OutlinedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: Color(0xFFF4C04E)),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Color(0xFF059669), fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
