class Place {
  final String name;
  final String location;
  final String image;
  final String description;
  final String category;
  final int elevation;
  final int rating;

  Place({
    required this.name,
    required this.location,
    required this.image,
    required this.description,
    required this.category,
    required this.elevation,
    required this.rating,
  });

  String get safeImageUrl =>
      image.isEmpty ? 'https://via.placeholder.com/150' : image;
}
