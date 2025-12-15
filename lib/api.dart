import 'model/place.dart';
import 'services/local_data_service.dart';

class ApiService {
  // Placeholder base URL for future implementation
  static const String baseUrl = 'https://api.sevenground.com/v1';

  static Future<List<Place>> getAllPlaces() async {
    // In a real app, we would try to fetch from API first,
    // then fallback to local DB or sync them.
    // For this requirement ("sqlite jika mobile"), we rely on LocalDataService.
    return await LocalDataService.getPlaces();
  }

  static Future<void> addPlace(final Place place) async {
    await LocalDataService.insertPlace(place);
  }

  static Future<void> updatePlace(final Place place) async {
    await LocalDataService.updatePlace(place);
  }

  static Future<void> deletePlace(final int id) async {
    await LocalDataService.deletePlace(id);
  }
}
