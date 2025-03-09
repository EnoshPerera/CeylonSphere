import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ARCameraView extends StatefulWidget {
  const ARCameraView({super.key});

  @override
  State<ARCameraView> createState() => _ARCameraViewState();
}

class _ARCameraViewState extends State<ARCameraView> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _showModel = true;
  bool _modelError = false;

  // Add position tracking
  Offset _position = Offset.zero;
  double _scale = 1.0;
  final double _baseSize = 200.0; // Base size of the image

  void _updateScale(double newScale) {
    final oldSize = _baseSize * _scale;
    final newSize = _baseSize * newScale;
    final sizeDiff = newSize - oldSize;

    setState(() {
      // Adjust position to keep image centered
      _position = Offset(
        _position.dx - sizeDiff / 2,
        _position.dy - sizeDiff / 2,
      );
      _scale = newScale;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    // Initialize position to center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _position = Offset(
            (size.width - _baseSize) / 2,
            (size.height - _baseSize) / 2,
          );
        });
      }
    });
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
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize!.height,
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          // AR Model Viewer
          if (_showModel)
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _position += details.delta;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/bamunu_mask_01.png',
                    fit: BoxFit.contain,
                    width: 200 * _scale,
                    height: 200 * _scale,
                  ),
                ),
              ),
            ),

          // Error Message
          if (_showModel && _modelError)
            const Center(
              child: Text(
                'Error loading the Image',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

          // Controls
          Positioned(
            top: 40,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'back',
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),

          // Scale Slider
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.zoom_out, color: Colors.white),
                  Expanded(
                    child: Slider(
                      value: _scale,
                      min: 0.5,
                      max: 3.0,
                      onChanged: _updateScale,
                      activeColor: Colors.white,
                    ),
                  ),
                  const Icon(Icons.zoom_in, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
