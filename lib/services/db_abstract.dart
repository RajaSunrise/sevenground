import '../model/place.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';

abstract class DatabaseHelper {
  Future<void> init();

  Future<List<Place>> getPlaces();
  Future<int> insertPlace(Place place);
  Future<int> updatePlace(Place place);
  Future<int> deletePlace(int id);

  Future<List<OrderTrip>> getOrders();
  Future<int> insertOrder(OrderTrip order);

  Future<int> registerUser(AppUser user);
  Future<AppUser?> loginUser(String email, String password);
}
