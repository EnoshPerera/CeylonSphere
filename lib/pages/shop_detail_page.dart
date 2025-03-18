import 'package:flutter/material.dart';
import '../model/shop.dart';
import '../model/item.dart';

// Simple Item model for the shop detail page
class Item {
  final int id;
  final String name;
  final String imagePath;
  final double price;
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.description,
  });
}

// Sample items for each shop
final List<Item> sampleItems = [
  Item(
    id: 1,
    name: 'Wooden Sculpture',
    imagePath: 'assets/images/item1.jpg',
    price: 45.99,
    description:
        'Hand-carved wooden sculpture made from sustainable local wood.',
  ),
  Item(
    id: 2,
    name: 'Woven Basket',
    imagePath: 'assets/images/item2.jpg',
    price: 29.99,
    description: 'Traditional woven basket perfect for storage or decoration.',
  ),
  Item(
    id: 3,
    name: 'Ceramic Vase',
    imagePath: 'assets/images/item3.jpg',
    price: 34.50,
    description: 'Handmade ceramic vase with unique glazing pattern.',
  ),
  Item(
    id: 4,
    name: 'Embroidered Pillow',
    imagePath: 'assets/images/item4.jpg',
    price: 27.99,
    description: 'Beautifully embroidered pillow with traditional patterns.',
  ),
  Item(
    id: 5,
    name: 'Handmade Candles',
    imagePath: 'assets/images/item5.jpg',
    price: 19.99,
    description: 'Set of 3 scented candles made with natural wax.',
  ),
];

class ShopDetailPage extends StatelessWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shop.name), centerTitle: true, elevation: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop header with image placeholder
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.store, size: 80, color: Colors.grey),
            ),
          ),

          // Shop info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shop.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            shop.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  shop.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${shop.itemCount})',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Items grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                10,
              ), // 10px padding at bottom for nav bar
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: sampleItems.length,
              itemBuilder: (context, index) {
                final item = sampleItems[index];
                return _buildItemCard(item);
              },
            ),
          ),

          // Space for bottom navigation bar (10px)
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildItemCard(Item item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),

            // This is a placeholder for item image
            child: const Center(
              child: Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
