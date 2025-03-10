class Item {
  final int id;
  final int shopId;
  final String name;
  final String imagePath;
  final double price;
  final String description;

  Item({
    required this.id,
    required this.shopId,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.description,
  });
}

final List<Item> items = [
  // Shop 1: Handcraft Haven
  Item(
    id: 1,
    shopId: 1,
    name: 'Wooden Sculpture',
    imagePath: 'assets/item1_1.jpg',
    price: 45.99,
    description: 'description',
  ),
  Item(
    id: 2,
    shopId: 1,
    name: 'Woven Basket',
    imagePath: 'assets/item1_2.jpg',
    price: 29.99,
    description: 'description',
  ),
  Item(
    id: 3,
    shopId: 1,
    name: 'Ceramic Vase',
    imagePath: 'assets/item1_3.jpg',
    price: 34.50,
    description: 'description',
  ),
  Item(
    id: 4,
    shopId: 1,
    name: 'Embroidered Pillow',
    imagePath: 'assets/item1_4.jpg',
    price: 27.99,
    description: 'description',
  ),
  Item(
    id: 5,
    shopId: 1,
    name: 'Handmade Candles',
    imagePath: 'assets/item1_5.jpg',
    price: 19.99,
    description: 'description',
  ),

  // Shop 2: Souvenir Spot
  Item(
    id: 6,
    shopId: 2,
    name: 'Miniature Landmark',
    imagePath: 'assets/item2_1.jpg',
    price: 15.99,
    description: 'description',
  ),
  Item(
    id: 7,
    shopId: 2,
    name: 'Postcard Collection',
    imagePath: 'assets/item2_2.jpg',
    price: 12.50,
    description: 'description',
  ),
  Item(
    id: 8,
    shopId: 2,
    name: 'Decorative Magnet',
    imagePath: 'assets/item2_3.jpg',
    price: 8.99,
    description: 'description',
  ),
  Item(
    id: 9,
    shopId: 2,
    name: 'Engraved Keychain',
    imagePath: 'assets/item2_4.jpg',
    price: 9.99,
    description: 'description',
  ),
  Item(
    id: 10,
    shopId: 2,
    name: 'Travel Journal',
    imagePath: 'assets/item2_5.jpg',
    price: 18.50,
    description: 'description',
  ),

  // Shop 3: Artisan Avenue
  Item(
    id: 11,
    shopId: 3,
    name: 'Handwoven Scarf',
    imagePath: 'assets/item3_1.jpg',
    price: 32.99,
    description: 'description',
  ),
  Item(
    id: 12,
    shopId: 3,
    name: 'Leather Journal',
    imagePath: 'assets/item3_2.jpg',
    price: 24.99,
    description: 'description',
  ),
  Item(
    id: 13,
    shopId: 3,
    name: 'Pottery Bowl Set',
    imagePath: 'assets/item3_3.jpg',
    price: 49.99,
    description: 'description',
  ),
  Item(
    id: 14,
    shopId: 3,
    name: 'Beaded Bracelet',
    imagePath: 'assets/item3_4.jpg',
    price: 16.50,
    description: 'description',
  ),
  Item(
    id: 15,
    shopId: 3,
    name: 'Carved Wooden Box',
    imagePath: 'assets/item3_5.jpg',
    price: 38.99,
    description: 'description',
  ),

  // Shop 4: Craft Corner
  Item(
    id: 16,
    shopId: 4,
    name: 'Macrame Wall Hanging',
    imagePath: 'assets/item4_1.jpg',
    price: 42.99,
    description: 'description',
  ),
  Item(
    id: 17,
    shopId: 4,
    name: 'Stained Glass Ornament',
    imagePath: 'assets/item4_2.jpg',
    price: 23.50,
    description: 'description',
  ),
  Item(
    id: 18,
    shopId: 4,
    name: 'Quilted Table Runner',
    imagePath: 'assets/item4_3.jpg',
    price: 36.99,
    description: 'description',
  ),
  Item(
    id: 19,
    shopId: 4,
    name: 'Pressed Flower Frame',
    imagePath: 'assets/item4_4.jpg',
    price: 29.99,
    description: 'description',
  ),
  Item(
    id: 20,
    shopId: 4,
    name: 'Hand-painted Coasters',
    imagePath: 'assets/item4_5.jpg',
    price: 18.99,
    description: 'description',
  ),

  // Shop 5: Memento Market
  Item(
    id: 21,
    shopId: 5,
    name: 'Custom Name Bracelet',
    imagePath: 'assets/item5_1.jpg',
    price: 22.99,
    description: 'description',
  ),
  Item(
    id: 22,
    shopId: 5,
    name: 'Photo Snow Globe',
    imagePath: 'assets/item5_2.jpg',
    price: 26.50,
    description: 'description',
  ),
  Item(
    id: 23,
    shopId: 5,
    name: 'Engraved Wooden Frame',
    imagePath: 'assets/item5_3.jpg',
    price: 31.99,
    description: 'description',
  ),
  Item(
    id: 24,
    shopId: 5,
    name: 'Memory Jar Kit',
    imagePath: 'assets/item5_4.jpg',
    price: 19.99,
    description: 'description',
  ),
  Item(
    id: 25,
    shopId: 5,
    name: 'Personalized Calendar',
    imagePath: 'assets/item5_5.jpg',
    price: 24.99,
    description: 'description',
  ),
];
