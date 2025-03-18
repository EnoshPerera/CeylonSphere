class Shop {
  final int id;
  final int categoryId; // To associate shops with categories
  final String name;
  final String imagePath; // Local asset path
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

// shops data
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

  // Textiles & Fabrics Shops (Category 2)
  Shop(
    id: 6,
    categoryId: 2,
    name: 'Textile Traditions',
    imagePath: 'assets/images/shop6.jpg',
    description: 'Handwoven textiles using traditional techniques',
    rating: 4.7,
    itemCount: 19,
  ),
  Shop(
    id: 7,
    categoryId: 2,
    name: 'Fabric Fusion',
    imagePath: 'assets/images/shop7.jpg',
    description: 'Blending traditional and modern textile designs',
    rating: 4.5,
    itemCount: 23,
  ),
  Shop(
    id: 8,
    categoryId: 2,
    name: 'Weaver\'s Workshop',
    imagePath: 'assets/images/shop8.jpg',
    description: 'Authentic handwoven fabrics from master weavers',
    rating: 4.8,
    itemCount: 16,
  ),

  // Cultural & Religious Souvenirs Shops (Category 3)
  Shop(
    id: 9,
    categoryId: 3,
    name: 'Cultural Keepsakes',
    imagePath: 'assets/images/shop9.jpg',
    description: 'Meaningful souvenirs representing local traditions',
    rating: 4.6,
    itemCount: 28,
  ),
  Shop(
    id: 10,
    categoryId: 3,
    name: 'Sacred Symbols',
    imagePath: 'assets/images/shop10.jpg',
    description: 'Religious artifacts and symbolic items',
    rating: 4.9,
    itemCount: 22,
  ),
  Shop(
    id: 11,
    categoryId: 3,
    name: 'Heritage Haven',
    imagePath: 'assets/images/shop11.jpg',
    description: 'Preserving cultural heritage through authentic souvenirs',
    rating: 4.7,
    itemCount: 25,
  ),

  // Jewelry & Accessories Shops (Category 4)
  Shop(
    id: 12,
    categoryId: 4,
    name: 'Artisan Adornments',
    imagePath: 'assets/images/shop12.jpg',
    description: 'Handcrafted jewelry with traditional designs',
    rating: 4.8,
    itemCount: 31,
  ),
  Shop(
    id: 13,
    categoryId: 4,
    name: 'Traditional Trinkets',
    imagePath: 'assets/images/shop13.jpg',
    description: 'Unique accessories inspired by cultural heritage',
    rating: 4.6,
    itemCount: 24,
  ),
  Shop(
    id: 14,
    categoryId: 4,
    name: 'Heritage Jewels',
    imagePath: 'assets/images/shop14.jpg',
    description: 'Jewelry pieces that tell stories of tradition',
    rating: 4.7,
    itemCount: 19,
  ),
];
