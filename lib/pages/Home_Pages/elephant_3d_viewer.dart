import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Elephant3DViewer extends StatelessWidget {
  const Elephant3DViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('3D Elephant Model'),
        backgroundColor: Color(0xFF003734),
        brightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFF003734),
                child: ModelViewer(
                  src: 'assets/models/Adiya.glb',
                  alt: 'A 3D model of a Sri Lankan elephant',
                  autoRotate: true,
                  cameraControls: true,
                  backgroundColor: const Color(0xFF003734),
                  disableZoom: false,
                  autoPlay: true,
                  shadowIntensity: 1,
                  exposure: 1.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF003734),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sri Lankan Elephant',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interact with the 3D model:',
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InteractionItem(
                        icon: CupertinoIcons.rotate_right,
                        label: 'Rotate',
                      ),
                      _InteractionItem(
                        icon: CupertinoIcons.zoom_in,
                        label: 'Zoom',
                      ),
                      _InteractionItem(
                        icon: CupertinoIcons.hand_draw,
                        label: 'Pan',
                      ),
                    ],
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

class _InteractionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InteractionItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: CupertinoColors.white,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
