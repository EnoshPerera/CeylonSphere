class Destination {
  final String name;
  final String description;
  final String imagePath;

  Destination(
      {required this.name, required this.description, required this.imagePath});
}

final List<Destination> destinations = [
  Destination(
    name: 'Pomegranate',
    description: 'Sweet, bell-shaped fruits enjoyed since ancient times.',
    imagePath: 'assets/Kandy.jpg',
  ),
  Destination(
    name: 'Apple',
    description: 'Apples are one of the most popular and healthy fruits.',
    imagePath: 'assets/Kandy.jpg',
  ),
  Destination(
    name: 'Mango',
    description: 'Mangoes are juicy, tropical fruits enjoyed worldwide.',
    imagePath: 'assets/Kandy.jpg',
  ),
  Destination(
    name: 'Gooseberry',
    description: 'Gooseberries are tart and perfect for desserts and jams.',
    imagePath: 'assets/Yala.jpg',
  ),
  Destination(
    name: 'Watermelon',
    description: 'A refreshing summer fruit rich in water content.',
    imagePath: 'assets/Yala.jpg',
  ),
  Destination(
    name: 'Cherry',
    description: 'Cherries are sweet, small fruits loved worldwide.',
    imagePath: 'assets/Yala.jpg',
  ),
];
