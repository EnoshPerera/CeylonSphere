class Shop {
  final int id;
  final int categoryId; // To associate shops with categories
  final String name;
  final String imagePath; // asset path
  final String description;
  final double rating;
  final int itemCount;

  Shop({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.itemCount,
  });
}

// Sample shops data
final List<Shop> shops = [
  // Traditional Handicrafts Shops (Category 1)
  Shop(
    id: 1,
    categoryId: 1,
    name: 'Handcraft Haven',
    imagePath: 'assets/images/shop1.jpg',
    description: 'Traditional handcrafted items from local artisans',
    rating: 4.8,
    itemCount: 24,
  ),
  Shop(
    id: 2,
    categoryId: 1,
    name: 'Artisan Avenue',
    imagePath: 'assets/images/shop2.jpg',
    description: 'Unique handmade crafts by skilled artisans',
    rating: 4.6,
    itemCount: 18,
  ),
  Shop(
    id: 3,
    categoryId: 1,
    name: 'Craft Corner',
    imagePath: 'assets/images/shop3.jpg',
    description: 'Beautiful crafts for your home and loved ones',
    rating: 4.7,
    itemCount: 32,
  ),
  Shop(
    id: 4,
    categoryId: 1,
    name: 'Heritage Handicrafts',
    imagePath: 'assets/images/shop4.jpg',
    description: 'Preserving traditional crafts for future generations',
    rating: 4.9,
    itemCount: 27,
  ),
  Shop(
    id: 5,
    categoryId: 1,
    name: 'Artisanal Treasures',
    imagePath: 'assets/images/shop5.jpg',
    description: 'Discover handcrafted treasures with cultural significance',
    rating: 4.5,
    itemCount: 21,
  ),
];
