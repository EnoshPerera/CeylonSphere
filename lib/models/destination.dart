class Destination {
  final String name;
  final String country;
  final String imagePath;
  final String description;
  final double rating;
  final List<String> categories;
  final List<String> galleryImages;
  final Map<String, List<String>> nearbyServices;

  Destination({
    required this.name,
    required this.country,
    required this.imagePath,
    required this.description,
    this.rating = 4.5,
    this.categories = const ['Historical', 'Cultural'],
    this.galleryImages = const [],
    this.nearbyServices = const {},
  });
}