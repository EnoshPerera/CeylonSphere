import 'package:flutter/material.dart';
import '../utils/location_utils.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = LocationUtils.getCategoryColor(title);
    final icon = LocationUtils.getCategoryIcon(title);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
} 