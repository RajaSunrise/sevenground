class Place {
  final int? id;
  final String name;
  final String location;
  final String image;
  final String description;
  final String category;
  final int elevation;
  final int rating;

  Place({
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'image': image,
      'description': description,
      'category': category,
      'elevation': elevation,
      'rating': rating,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'],
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      elevation: map['elevation'] ?? 0,
      rating: map['rating'] ?? 0,
    );
  }
}
