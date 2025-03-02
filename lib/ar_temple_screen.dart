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
  String? selectedModel;

  final List<ARExperience> arExperiences = [
    ARExperience(
      title: 'Temple of the Tooth',
      description: 'Explore the sacred Temple of the Tooth in AR',
      modelPath: 'AirForce.usdz',
      thumbnail: 'assets/Kandy.jpg',
    ),
    ARExperience(
      title: 'Sigiriya Rock',
      description: 'Ancient palace and fortress complex',
      modelPath: 'AirForce.usdz',
      thumbnail: 'assets/Sigiriya.jpg',
    ),
    ARExperience(
      title: 'Jetavanaramaya',
      description: 'Ancient Buddhist stupa',
      modelPath: 'AirForce.usdz',
      thumbnail: 'assets/Jetavanaramaya.jpg',
    ),
    ARExperience(
      title: 'Ruwanwelisaya',
      description: 'Sacred stupa in Anuradhapura',
      modelPath: 'AirForce.usdz',
      thumbnail: 'assets/ruwanwelisaya.jpg',
    ),
  ];

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('AR Experiences'),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Column(
          children: [
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
                      setState(() {
                        selectedModel = arExperiences[index].modelPath;
                        if (node != null) {
                          arkitController.remove(node!.name);
                          addUpdatedNode();
                        }
                      });
                    },
                  );
                },
              ),
            ),
            // Instructions
            if (selectedModel == null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.cube_box,
                        size: 64,
                        color: Color(0xFF6200EA),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select a monument to view in AR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6200EA),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Experience Sri Lankan heritage in augmented reality',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: GestureDetector(
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    setState(() {
                      if (node != null) {
                        currentScale = details.scale;
                        currentRotation += details.rotation;
                        arkitController.remove(node!.name);
                        addUpdatedNode();
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      ARKitSceneView(
                        onARKitViewCreated: onARKitViewCreated,
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pinch to zoom • Rotate with two fingers',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
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

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    if (selectedModel != null) {
      addUpdatedNode();
    }
  }

  void addUpdatedNode() {
    node = ARKitReferenceNode(
      url: selectedModel!,
      scale: vector.Vector3.all(currentScale),
      position: vector.Vector3(0, 0, -1),
      eulerAngles: vector.Vector3(0, currentRotation, 0),
    );
    arkitController.add(node!);
  }
}

class ARExperience {
  final String title;
  final String description;
  final String modelPath;
  final String thumbnail;

  const ARExperience({
    required this.title,
    required this.description,
    required this.modelPath,
    required this.thumbnail,
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
              ? Border.all(color: const Color(0xFF6200EA), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                experience.thumbnail,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
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
      ),
    );
  }
}
