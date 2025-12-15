import '../model/place.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';
import 'db_helper.dart';

class LocalDataService {

  static final _helper = DatabaseHelperFactory.getHelper();

  // ====================== PLACES ======================

  static Future<List<Place>> getPlaces() async {
    return await _helper.getPlaces();
  }

  static Future<int> insertPlace(final Place place) async {
    return await _helper.insertPlace(place);
  }

  static Future<int> updatePlace(final Place place) async {
    return await _helper.updatePlace(place);
  }

  static Future<int> deletePlace(final int id) async {
    return await _helper.deletePlace(id);
  }

  // ====================== ORDERS ======================

  static Future<List<OrderTrip>> getOrders() async {
    return await _helper.getOrders();
  }

  static Future<int> insertOrder(final OrderTrip order) async {
    return await _helper.insertOrder(order);
  }

  // ====================== USERS ======================

  static Future<int> registerUser(final AppUser user) async {
    return await _helper.registerUser(user);
  }

  static Future<AppUser?> loginUser(final String email, final String password) async {
    return await _helper.loginUser(email, password);
  }
}
