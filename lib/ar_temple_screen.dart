import 'package:flutter/cupertino.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'elephant_3d_viewer.dart';

class ARTempleScreen extends StatefulWidget {
  const ARTempleScreen({super.key});

  @override
  _ARTempleScreenState createState() => _ARTempleScreenState();
}

class _ARTempleScreenState extends State<ARTempleScreen> {
  late ARKitController arkitController;
  ARKitReferenceNode? node;
  double currentScale = 1.0;
  double currentRotation = 0.0;
  String? selectedModel;
  bool isPlaneDetected = false;

  static const List<ARExperience> arExperiences = [
    ARExperience(
      title: 'Temple of the Tooth',
      description: 'Coming Soon',
      modelPath: '',
      thumbnail: 'assets/Kandy.jpg',
      isComingSoon: true,
      isARMode: true,
    ),
    ARExperience(
      title: 'Sigiriya Rock',
      description: 'Coming Soon',
      modelPath: '',
      thumbnail: 'assets/Sigiriya.jpg',
      isComingSoon: true,
      isARMode: true,
    ),
    ARExperience(
      title: 'Jetavanaramaya',
      description: 'Coming Soon',
      modelPath: '',
      thumbnail: 'assets/Jetavanaramaya.jpg',
      isComingSoon: true,
      isARMode: true,
    ),
    ARExperience(
      title: 'Ruwanwelisaya',
      description: 'Coming Soon',
      modelPath: '',
      thumbnail: 'assets/ruwanwelisaya.jpg',
      isComingSoon: true,
      isARMode: true,
    ),
    ARExperience(
      title: 'Sri Lankan Elephant',
      description: 'View our majestic elephant in 3D',
      modelPath: 'Adiya.glb',
      thumbnail: 'assets/elephant.jpg',
      isComingSoon: false,
      isARMode: false,
    ),
  ];

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
    arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;

    // Enable plane detection
    arkitController.addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitPlaneAnchor) {
      setState(() {
        isPlaneDetected = true;
      });
      if (selectedModel != null) {
        addUpdatedNode(anchor);
      }
    }
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitPlaneAnchor && node != null) {
      final position = anchor.transform.getColumn(3);
      node?.position = vector.Vector3(position.x, position.y, position.z);
      arkitController.update(node!.name);
    }
  }

  void addUpdatedNode(ARKitAnchor anchor) {
    if (node != null) {
      arkitController.remove(node!.name);
    }

    final position = anchor.transform.getColumn(3);
    node = ARKitReferenceNode(
      url: selectedModel!,
      scale: vector.Vector3.all(currentScale),
      position: vector.Vector3(position.x, position.y, position.z),
      eulerAngles: vector.Vector3(0, currentRotation, 0),
    );
    arkitController.add(node!);
  }

  void _show3DViewer(ARExperience experience) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFF003734),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    experience.title,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: CupertinoColors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ARKitSceneView(
                    onARKitViewCreated: (ARKitController controller) {
                      final node = ARKitReferenceNode(
                        url: experience.modelPath,
                        scale: vector.Vector3.all(1.0),
                        position: vector.Vector3(0, 0, -0.5),
                        eulerAngles: vector.Vector3(0, 0, 0),
                      );
                      controller.add(node);

                      // Add ambient light
                      final light = ARKitNode(
                        geometry: ARKitSphere(radius: 0.1),
                        light: ARKitLight(
                          type: ARKitLightType.ambient,
                          intensity: 1000,
                        ),
                        position: vector.Vector3(0, 1, 0),
                      );
                      controller.add(light);
                    },
                    showFeaturePoints: false,
                    showWorldOrigin: false,
                    showStatistics: false,
                  ),
                  // Controls overlay
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: CupertinoColors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.hand_draw,
                              color: CupertinoColors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Pinch to zoom • Drag to rotate',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('AR Experiences'),
        previousPageTitle: 'Back',
        backgroundColor: Color(0xFF003734),
        brightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // // Header Section
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   color: const Color(0xFF003734),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Explore Sri Lankan Heritage',
            //         style: TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: CupertinoColors.white,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         'Experience historical monuments in augmented reality',
            //         style: TextStyle(
            //           fontSize: 14,
            //           color: CupertinoColors.white.withOpacity(0.7),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // AR Experience Cards
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: arExperiences.length,
                itemBuilder: (context, index) {
                  return _ARExperienceCard(
                    experience: arExperiences[index],
                    isSelected: arExperiences[index].modelPath == selectedModel,
                    onTap: () {
                      if (!arExperiences[index].isComingSoon) {
                        if (arExperiences[index].isARMode) {
                          setState(() {
                            selectedModel = arExperiences[index].modelPath;
                            if (node != null) {
                              arkitController.remove(node!.name);
                              if (isPlaneDetected) {
                                final position = vector.Vector3(0, 0, -1);
                                node = ARKitReferenceNode(
                                  url: selectedModel!,
                                  scale: vector.Vector3.all(currentScale),
                                  position: position,
                                  eulerAngles:
                                      vector.Vector3(0, currentRotation, 0),
                                );
                                arkitController.add(node!);
                              }
                            }
                          });
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const Elephant3DViewer(),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
            // AR View
            Expanded(
              child: Stack(
                children: [
                  ARKitSceneView(
                    onARKitViewCreated: onARKitViewCreated,
                    planeDetection: ARPlaneDetection.horizontal,
                    worldAlignment: ARWorldAlignment.gravity,
                  ),
                  if (!isPlaneDetected)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: CupertinoColors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              CupertinoIcons.viewfinder,
                              color: CupertinoColors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Move your device to detect a surface',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Point your camera at a flat surface',
                              style: TextStyle(
                                color: CupertinoColors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (isPlaneDetected && selectedModel != null)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: CupertinoColors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                CupertinoIcons.hand_draw,
                                color: CupertinoColors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tap to place • Pinch to zoom • Rotate with two fingers',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ARExperience {
  final String title;
  final String description;
  final String modelPath;
  final String thumbnail;
  final bool isComingSoon;
  final bool isARMode;

  const ARExperience({
    required this.title,
    required this.description,
    required this.modelPath,
    required this.thumbnail,
    this.isComingSoon = false,
    this.isARMode = true,
  });
}

class _ARExperienceCard extends StatelessWidget {
  final ARExperience experience;
  final bool isSelected;
  final VoidCallback onTap;

  const _ARExperienceCard({
    required this.experience,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFF003734), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      Image.asset(
                        experience.thumbnail,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      if (!experience.isComingSoon)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF003734).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.cube_box_fill,
                                  color: CupertinoColors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'AR Ready',
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003734),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        experience.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (experience.isComingSoon)
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.clock,
                        color: CupertinoColors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Coming Soon',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
