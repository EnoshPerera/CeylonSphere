class Shop {
  final int id;
  final String name;
  final String imageUrl;
  final String description;

  Shop({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

// Sample data
final List<Shop> shops = [
  Shop(
    id: 1,
    name: 'Handcraft Haven',
    imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=300',
    description: 'Traditional handcrafted items from local artisans',
  ),
  Shop(
    id: 2,
    name: 'Souvenir Spot',
    imageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?q=80&w=300',
    description: 'Memorable souvenirs from around the world',
  ),
  Shop(
    id: 3,
    name: 'Artisan Avenue',
    imageUrl: 'https://images.unsplash.com/photo-1482501157762-56897a411e05?q=80&w=300',
    description: 'Unique handmade crafts by skilled artisans',
  ),
  Shop(
    id: 4,
    name: 'Craft Corner',
    imageUrl: 'https://images.unsplash.com/photo-1464195244916-405fa0a82545?q=80&w=300',
    description: 'Beautiful crafts for your home and loved ones',
  ),
  Shop(
    id: 5,
    name: 'Memento Market',
    imageUrl: 'https://images.unsplash.com/photo-1467293622093-9f15c96be70f?q=80&w=300',
    description: 'Special keepsakes to remember your journey',
  ),
];

