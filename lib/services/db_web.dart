import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/place.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';
import 'db_abstract.dart';

class DatabaseHelperImpl implements DatabaseHelper {
  static const String _keyPlaces = 'web_places';
  static const String _keyOrders = 'web_orders';
  static const String _keyUsers = 'web_users';

  @override
  Future<void> init() async {
    // No specific init needed for SharedPrefs, but we can seed here if needed
  }

  // ====================== PLACES ======================

  @override
  Future<List<Place>> getPlaces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_keyPlaces);
    if (jsonStr == null) {
      // Seed initial data
       final List<Place> seeds = [
        Place(
          id: 1,
          name: 'Gunung Rinjani',
          location: 'Lombok',
          image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
          description: 'Gunung tertinggi di Lombok',
          category: 'mountain',
          elevation: 3726,
          rating: 5,
        ),
        Place(
          id: 2,
          name: 'Pantai Tanjung Aan',
          location: 'Lombok',
          image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
          description: 'Pantai cantik dengan pasir putih',
          category: 'beach',
          elevation: 0,
          rating: 4,
        ),
      ];
      await _savePlacesWeb(seeds);
      return seeds;
    }
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((final e) => Place.fromMap(e)).toList();
  }

  Future<void> _savePlacesWeb(final List<Place> places) async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String jsonStr = jsonEncode(places.map((final e) => e.toMap()).toList());
     await prefs.setString(_keyPlaces, jsonStr);
  }

  @override
  Future<int> insertPlace(final Place place) async {
    final List<Place> current = await getPlaces();
    final int newId = (current.isEmpty ? 0 : current.last.id ?? 0) + 1;
    final Place newPlace = Place(
      id: newId,
      name: place.name,
      location: place.location,
      image: place.image,
      description: place.description,
      category: place.category,
      elevation: place.elevation,
      rating: place.rating,
    );
    current.add(newPlace);
    await _savePlacesWeb(current);
    return newId;
  }

  @override
  Future<int> updatePlace(final Place place) async {
    final List<Place> current = await getPlaces();
    final int index = current.indexWhere((final p) => p.id == place.id);
    if (index != -1) {
      current[index] = place;
      await _savePlacesWeb(current);
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deletePlace(final int id) async {
    final List<Place> current = await getPlaces();
    final int initialLen = current.length;
    current.removeWhere((final p) => p.id == id);
    if (current.length < initialLen) {
      await _savePlacesWeb(current);
      return 1;
    }
    return 0;
  }

  // ====================== ORDERS ======================

  @override
  Future<List<OrderTrip>> getOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_keyOrders);
    if (jsonStr == null) return [];
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((final e) => OrderTrip.fromMap(e)).toList();
  }

  @override
  Future<int> insertOrder(final OrderTrip order) async {
    final List<OrderTrip> current = await getOrders();
     final int newId = (current.isEmpty ? 0 : current.last.id ?? 0) + 1;
     final Map<String, dynamic> map = order.toMap();
     map['id'] = newId;
     current.add(OrderTrip.fromMap(map));

     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String jsonStr = jsonEncode(current.map((final e) => e.toMap()).toList());
     await prefs.setString(_keyOrders, jsonStr);
     return newId;
  }

  // ====================== USERS ======================

  Future<List<AppUser>> _getUsersWeb() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_keyUsers);
    if (jsonStr == null) return [];
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((final e) => AppUser.fromMap(e)).toList();
  }

  @override
  Future<int> registerUser(final AppUser user) async {
    final List<AppUser> current = await _getUsersWeb();
    if (current.any((final u) => u.email == user.email)) {
      return -1;
    }
    final int newId = (current.isEmpty ? 0 : current.last.id ?? 0) + 1;
    final Map<String, dynamic> map = user.toMap();
    map['id'] = newId;
    current.add(AppUser.fromMap(map));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonStr = jsonEncode(current.map((final e) => e.toMap()).toList());
    await prefs.setString(_keyUsers, jsonStr);
    return newId;
  }

  @override
  Future<AppUser?> loginUser(final String email, final String password) async {
    final List<AppUser> current = await _getUsersWeb();
    try {
      return current.firstWhere((final u) => u.email == email && u.password == password);
    } catch (e) {
      return null;
    }
  }
}
