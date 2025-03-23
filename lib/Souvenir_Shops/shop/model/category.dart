import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String imagePath;
  final String description;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.icon,
  });
}

// categories data
final List<Category> categories = [
  Category(
    id: 1,
    name: 'Traditional Handicrafts',
    imagePath: "assets/category_traditional.jpg",
    description:
        'Discover authentic handcrafted items made by skilled artisans using traditional techniques passed down through generations. These unique pieces showcase cultural heritage and exceptional craftsmanship.',
    icon: Icons.handyman,
  ),

  Category(
    id: 2,
    name: 'Textiles & Fabrics',
    imagePath: 'assets/category_textiles.png',
    description:
        'Explore beautiful handwoven textiles and fabrics created using traditional looms and techniques. Each piece tells a story of cultural heritage and artistic expression.',
    icon: Icons.style,
  ),

  Category(
    id: 3,
    name: 'Cultural & Religious Souvenirs',
    imagePath: 'assets/category_cultural.png',
    description:
        'Browse our collection of meaningful cultural and religious items that represent local traditions, beliefs, and practices. Perfect as souvenirs or gifts.',
    icon: Icons.temple_buddhist,
  ),
];
