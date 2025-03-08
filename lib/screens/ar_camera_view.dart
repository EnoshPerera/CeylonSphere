import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARCameraView extends StatefulWidget {
  const ARCameraView({super.key});

  @override
  State<ARCameraView> createState() => _ARCameraViewState();
}

class _ARCameraViewState extends State<ARCameraView> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _showModel = false;
  bool _modelError = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller?.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _initializeControllerFuture == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          // 3D Model Viewer
          if (_showModel)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                child: ModelViewer(
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  src: 'assets/models/wooden_mask.glb',
                  alt: "A 3D model of a wooden mask",
                  ar: true,
                  arModes: const ['scene-viewer', 'webxr', 'quick-look'],
                  autoRotate: true,
                  cameraControls: true,
                  disableZoom: false,
                ),
              ),
            ),

          // Error Message
          if (_showModel && _modelError)
            const Center(
              child: Text(
                'Error loading 3D model',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

          // Controls
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'back',
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
                FloatingActionButton(
                  heroTag: 'toggle',
                  onPressed: () {
                    setState(() {
                      _showModel = !_showModel;
                      if (_showModel) _modelError = false;
                    });
                  },
                  child:
                      Icon(_showModel ? Icons.hide_source : Icons.view_in_ar),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
