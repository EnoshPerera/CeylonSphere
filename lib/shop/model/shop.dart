class Shop {
  final int id;
  final int categoryId; // To associate shops with categories
  final String name;
  final String imagePath; // Local asset path
  final String description;
  final double rating;
  final String location;
  final String contactInfo;

  Shop({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.location,
    required this.contactInfo,
  });
}

// shops data
final List<Shop> shops = [
  // Traditional Handicrafts Shops (Category 1)
  Shop(
    id: 1,
    categoryId: 1,
    name: 'Heritage Crafts Lanka',
    imagePath: 'assets/shop1.jpg',
    description:
        'Traditional handcrafted items from sri lankan artisans with a focus on quality and authenticity.',
    rating: 4.8,
    location: 'Central Market, Ambangoda',
    contactInfo: '070-1196313',
  ),

  // Textiles & Fabrics Shops (Category 2)
  Shop(
    id: 2,
    categoryId: 2,
    name: 'Ceylon Fabric House',
    imagePath: 'assets/shop2.jpg',
    description:
        'Handwoven textiles using traditional techniques passed down through generations.',
    rating: 4.7,
    location: 'Weaver\'s Market Hikkaduwa',
    contactInfo: '071-3651261',
  ),

  // Cultural & Religious Souvenirs Shops (Category 3)
  Shop(
    id: 3,
    categoryId: 3,
    name: 'Divine Gifts Lanka',
    imagePath: 'assets/shop3.jpg',
    description:
        'Meaningful souvenirs representing sri lankan traditions and cultural heritage.',
    rating: 4.6,
    location: 'Tourist Center Galle',
    contactInfo: '077-8718323',
  ),
];
