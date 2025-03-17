import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'popup_page.dart'; // Import the popup class

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Dark green background
        decoration: const BoxDecoration(
          color: Color(0xFF004D40), // Dark green color
        ),
        child: SafeArea(
          child: Column(
              children: [
              const SizedBox(height: 40),
          // App Logo
          Image.asset(
            'assets/Logo-12.png', // Replace with your app logo
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          // 3D Model Viewer without Shadow
          Expanded(
            child: Center(
              child: SizedBox(
                width: 500,
                height: 320,
                child: ModelViewer(
                  backgroundColor: Colors.transparent,
                  src: 'assets/app_island.glb',
                  alt: 'A 3D model',
                  autoPlay: true,
                  disableZoom: true,
                  cameraControls: true,
                  autoRotate: true,
                  scale: "10 10 10",
                  cameraOrbit: "0deg 60deg 2m", // Initial camera angle
                  minCameraOrbit: "-Infinity 60deg 2m", // Restrict vertical movement
                  maxCameraOrbit: "Infinity 60deg 2m", // Restrict vertical movement
                  cameraTarget: "0m 0m 0m",
                  relatedCss: """
                        .progress-bar {
                          display: none !important;
                        }
                      """,
                ),
              ),
            ),
          ),
          // Modern iOS-style Get Started Button (Smaller Size)
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: Container(
              width: 200, // Smaller width
              height: 40, // Smaller height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                  )],
                  gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    WelcomePopup.show(context); // Show popup
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 16, // Smaller font size
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF004D40),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.arrow_right,
                          size: 16, // Smaller icon size
                          color: const Color(0xFF004D40).withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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