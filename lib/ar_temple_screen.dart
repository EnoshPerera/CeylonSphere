import 'package:flutter/cupertino.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARTempleScreen extends StatefulWidget {
  @override
  _ARTempleScreenState createState() => _ARTempleScreenState();
}

class _ARTempleScreenState extends State<ARTempleScreen> {
  late ARKitController arkitController;
  ARKitReferenceNode? node;
  double currentScale = 1.0;
  double currentRotation = 0.0;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Temple AR View'),
        previousPageTitle: 'Back',
      ),
      child: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            if (node != null) {
              currentScale = details.scale;
              currentRotation += details.rotation; // Update rotation

              // Remove old node and add new updated one
              arkitController.remove(node!.name);
              addUpdatedNode();
            }
          });
        },
        child: ARKitSceneView(
          onARKitViewCreated: onARKitViewCreated,
        ),
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    addUpdatedNode();
  }

  void addUpdatedNode() {
    node = ARKitReferenceNode(
      url: 'AirForce.usdz', // 3D model path
      scale: vector.Vector3.all(currentScale), // Updated scale
      position: vector.Vector3(0, 0, -1), // Position 1 meter ahead
      eulerAngles: vector.Vector3(0, currentRotation, 0), // Rotation
    );

    arkitController.add(node!);
  }
}
