class Destination {
  final String name;
  final String country;
  final String imagePath;
  final String description;
  final bool isCrowded;

  Destination({
    required this.name,
    required this.country,
    required this.imagePath,
    required this.description,
    this.isCrowded = false,
  });
}