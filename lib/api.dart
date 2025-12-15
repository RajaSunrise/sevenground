import 'model/place.dart';

class ApiService {
  static Future<List<Place>> getAllPlaces() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Place(
        name: 'Gunung Rinjani',
        location: 'Lombok',
        category: 'mountain',
        image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        description: 'Gunung tertinggi di Lombok',
        elevation: 3726,
        rating: 5,
      ),
      Place(
        name: 'Pantai Tanjung Aan',
        location: 'Lombok',
        category: 'beach',
        image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
        description: 'Pantai cantik dengan pasir putih',
        elevation: 0,
        rating: 4,
      ),
    ];
  }

  static Future<void> addPlace(final Place place) async {
    await Future.delayed(const Duration(seconds: 1));
    print('Place added: ${place.name}');
  }
}
