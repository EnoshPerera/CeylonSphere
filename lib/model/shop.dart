class Shop {
  final int id;
  final String name;
  final String imagePath;
  final String description;

  Shop({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

final List<Shop> shops = [
  Shop(
    id: 1,
    name: 'Handcraft Haven',
    imagePath: 'assets/shop_image1.jpg',
    description: 'Traditional handcrafted items from local artisans',
  ),
  Shop(
    id: 2,
    name: 'Souvenir Spot',
    imagePath: 'assets/shop_image2.webp',
    description: 'Memorable souvenirs from around the world',
  ),
  Shop(
    id: 3,
    name: 'Artisan Avenue',
    imagePath: 'assets/shop_image3.jpg',
    description: 'Unique handmade crafts by skilled artisans',
  ),
  Shop(
    id: 4,
    name: 'Craft Corner',
    imagePath: 'assets/shop_image4.avif',
    description: 'Beautiful crafts for your home and loved ones',
  ),
  Shop(
    id: 5,
    name: 'Memento Market',
    imagePath: 'assets/shop_image5.jpg',
    description: 'Special keepsakes to remember your journey',
  ),
];
