class Category {
  final int id;
  final String name;
  final String imagePath; // Local asset path for category icon
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

// Sample categories data
final List<Category> categories = [
  Category(
    id: 1,
    name: 'Traditional Handicrafts',
    imagePath:
        'assets/images/category_traditional.png', // Placeholder for your image
    description:
        'Discover authentic handcrafted items made by skilled artisans using traditional techniques passed down through generations. These unique pieces showcase cultural heritage and exceptional craftsmanship.',
  ),
];
