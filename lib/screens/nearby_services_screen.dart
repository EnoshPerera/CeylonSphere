// import 'package:flutter/material.dart';
// import 'restaurants_page.dart'; // Import the restaurant page

// class NearbyServicesScreen extends StatelessWidget {
//   final List<Map<String, String>> services = [
//     {"name": "Restaurants", "image": "assets/restaurants.jpg"},
//     {"name": "Supermarket", "image": "assets/supermarket.jpg"},
//     {"name": "Souvenir Shops", "image": "assets/souvenir_shops.jpg"},
//     {"name": "Transport", "image": "assets/transport.jpg"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Services"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 1,
//           ),
//           itemCount: services.length,
//           itemBuilder: (context, index) {
//             return ServiceCard(
//               title: services[index]["name"]!,
//               imagePath: services[index]["image"]!,
//               onTap: () {
//                 // Navigate to the Restaurant Page if user clicks on "Restaurants"
//                 if (services[index]["name"] == "Restaurants") {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => RestaurantPage()),
//                   );
//                 }
//                 // TODO: Navigate to details page
//                 debugPrint("${services[index]["name"]} clicked");
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class ServiceCard extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final VoidCallback onTap;

//   const ServiceCard({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//map
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NearbyServicesScreen extends StatefulWidget {
//   @override
//   _NearbyServicesScreenState createState() => _NearbyServicesScreenState();
// }

// class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
//   GoogleMapController? mapController;

//   final LatLng sriLankaCenter = const LatLng(7.8731, 80.7718); // Center of Sri Lanka

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void openGoogleMapsForRestaurants() async {
//     final Uri googleMapsUrl = Uri.parse(
//         "https://www.google.com/maps/search/?api=1&query=restaurants+in+Sri+Lanka");

//     if (await canLaunchUrl(googleMapsUrl)) {
//       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//     } else {
//       throw "Could not launch Google Maps";
//     }
//   }

//   final List<Map<String, String>> services = [
//     {"name": "Restaurants", "image": "assets/restaurants.jpg"},
//     {"name": "Supermarket", "image": "assets/supermarket.jpg"},
//     {"name": "Souvenir Shops", "image": "assets/souvenir_shops.jpg"},
//     {"name": "Transport", "image": "assets/transport.jpg"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Services"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Google Map Section
//           Expanded(
//             flex: 2,
//             child: GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: sriLankaCenter,
//                 zoom: 7.0, // Adjust zoom level for Sri Lanka
//               ),
//               markers: {
//                 Marker(
//                   markerId: MarkerId("restaurant"),
//                   position: LatLng(6.9271, 79.8612), // Example: Colombo location
//                   infoWindow: InfoWindow(title: "Nearby Restaurants"),
//                 ),
//               },
//             ),
//           ),
//           // Service Cards Section
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 1,
//                 ),
//                 itemCount: services.length,
//                 itemBuilder: (context, index) {
//                   return ServiceCard(
//                     title: services[index]["name"]!,
//                     imagePath: services[index]["image"]!,
//                     onTap: () {
//                       // Open Google Maps for nearby restaurants instead of navigating to RestaurantPage
//                       if (services[index]["name"] == "Restaurants") {
//                         openGoogleMapsForRestaurants();
//                       }
//                       debugPrint("${services[index]["name"]} clicked");
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ServiceCard extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final VoidCallback onTap;

//   const ServiceCard({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// 3rd map
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NearbyServicesScreen extends StatefulWidget {
//   @override
//   _NearbyServicesScreenState createState() => _NearbyServicesScreenState();
// }

// class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
//   GoogleMapController? mapController;
//   LatLng? userLocation;

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   Future<void> _getUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       userLocation = LatLng(position.latitude, position.longitude);
//       if (mapController != null) {
//         mapController!.animateCamera(CameraUpdate.newLatLng(userLocation!));
//       }
//     });
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     if (userLocation != null) {
//       mapController!.animateCamera(CameraUpdate.newLatLng(userLocation!));
//     }
//   }

//   void openGoogleMapsForRestaurants() async {
//     final Uri googleMapsUrl = Uri.parse(
//         "https://www.google.com/maps/search/?api=1&query=restaurants+near+me");

//     if (await canLaunchUrl(googleMapsUrl)) {
//       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//     } else {
//       throw "Could not launch Google Maps";
//     }
//   }

//   final List<Map<String, String>> services = [
//     {"name": "Restaurants", "image": "assets/restaurants.jpg"},
//     {"name": "Supermarket", "image": "assets/supermarket.jpg"},
//     {"name": "Souvenir Shops", "image": "assets/souvenir_shops.jpg"},
//     {"name": "Transport", "image": "assets/transport.jpg"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nearby Services"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: userLocation ?? LatLng(7.8731, 80.7718),
//                 zoom: 10.0,
//               ),
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 1,
//                 ),
//                 itemCount: services.length,
//                 itemBuilder: (context, index) {
//                   return ServiceCard(
//                     title: services[index]["name"]!,
//                     imagePath: services[index]["image"]!,
//                     onTap: () {
//                       if (services[index]["name"] == "Restaurants") {
//                         openGoogleMapsForRestaurants();
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ServiceCard extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final VoidCallback onTap;

//   const ServiceCard({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyServicesScreen extends StatefulWidget {
  @override
  _NearbyServicesScreenState createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  GoogleMapController? mapController;
  LatLng? userLocation;
  Set<Marker> _markers = {};
  final String apiKey = "AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s"; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(userLocation!));
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (userLocation != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(userLocation!));
    }
  }

  void _openRestaurantMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantMapScreen(userLocation: userLocation, apiKey: apiKey),
      ),
    );
  }

  final List<Map<String, String>> services = [
    {"name": "Restaurants", "image": "assets/restaurants.jpg"},
    {"name": "Supermarket", "image": "assets/supermarket.jpg"},
    {"name": "Souvenir Shops", "image": "assets/souvenir_shops.jpg"},
    {"name": "Transport", "image": "assets/transport.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Services")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: userLocation ?? LatLng(7.8731, 80.7718),
                zoom: 10.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (services[index]["name"] == "Restaurants") {
                        _openRestaurantMap(context);
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                services[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              services[index]["name"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantMapScreen extends StatefulWidget {
  final LatLng? userLocation;
  final String apiKey;

  const RestaurantMapScreen({Key? key, this.userLocation, required this.apiKey}) : super(key: key);

  @override
  _RestaurantMapScreenState createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchNearbyRestaurants();
  }

  Future<void> _fetchNearbyRestaurants() async {
    if (widget.userLocation == null) return;

    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.userLocation!.latitude},${widget.userLocation!.longitude}&radius=5000&type=restaurant&key=${widget.apiKey}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data["results"];

      setState(() {
        _markers.clear();
        for (var result in results) {
          _markers.add(
            Marker(
              markerId: MarkerId(result["place_id"]),
              position: LatLng(
                result["geometry"]["location"]["lat"],
                result["geometry"]["location"]["lng"],
              ),
              infoWindow: InfoWindow(title: result["name"]),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Restaurants")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.userLocation ?? LatLng(7.8731, 80.7718),
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }
}
