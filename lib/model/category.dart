class Category {
  final int id;
  final String name;
  final String imagePath; // asset path for category icon
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

// categories data
final List<Category> categories = [
  Category(
    id: 1,
    name: 'Traditional Handicrafts',
    imagePath: 'assets/images/category_traditional.png',
    description:
        'Discover authentic handcrafted items made by skilled artisans using traditional techniques passed down through generations. These unique pieces showcase cultural heritage and exceptional craftsmanship.',
  ),

  Category(
    id: 2,
    name: 'Textiles & Fabrics',
    imagePath: 'assets/images/category_textiles.png',
    description:
        'Explore beautiful handwoven textiles and fabrics created using traditional looms and techniques. Each piece tells a story of cultural heritage and artistic expression.',
  ),

  Category(
    id: 3,
    name: 'Cultural & Religious Souvenirs',
    imagePath: 'assets/images/category_cultural.png',
    description:
        'Browse our collection of meaningful cultural and religious items that represent local traditions, beliefs, and practices. Perfect as souvenirs or gifts.',
  ),

  Category(
    id: 4,
    name: 'Jewelry & Accessories',
    imagePath: 'assets/images/category_jewelry.png',
    description:
        'Find handcrafted jewelry and accessories made with traditional techniques and materials. Each piece is unique and reflects local artistry and craftsmanship.',
  ),
];
