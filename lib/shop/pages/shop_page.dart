import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/shop.dart';
import '../widgets/category_card.dart';
import '../widgets/shop_card.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedCategoryId =
      1; // Default to first category (Traditional Handicrafts)

  @override
  Widget build(BuildContext context) {
    // Get shops for the selected category
    final categoryShops =
        shops.where((shop) => shop.categoryId == _selectedCategoryId).toList();

    // Get the selected category
    final selectedCategory = categories.firstWhere(
      (category) => category.id == _selectedCategoryId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Explore Stores'),
            const SizedBox(width: 8),
            const Icon(Icons.store, size: 24),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  isSelected: category.id == _selectedCategoryId,
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                );
              },
            ),
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(),
          ),

          // Selected category title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              selectedCategory.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 114, 82),
              ),
            ),
          ),

          // Category description
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 2, 222, 148),
                ),
              ),
              child: Text(
                selectedCategory.description,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 0, 55, 52),
                ),
              ),
            ),
          ),

          // Shops section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                const Text(
                  'Shops',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${categoryShops.length})',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Shops list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                10,
              ), // 10px padding at bottom for nav bar
              itemCount: categoryShops.length,
              itemBuilder: (context, index) {
                return ShopCard(shop: categoryShops[index]);
              },
            ),
          ),

          // Space for bottom navigation bar (10px)
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
