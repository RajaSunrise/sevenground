import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import 'local_data_service.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserName = 'userName';

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<Map<String, String>> getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyUserEmail) ?? '',
      'name': prefs.getString(_keyUserName) ?? 'User',
    };
  }

  static Future<bool> login(final String email, final String password) async {
    // Check against Local Data Service (SQLite/JSON)
    final AppUser? user = await LocalDataService.loginUser(email, password);

    if (user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserEmail, user.email);
      await prefs.setString(_keyUserName, user.name);
      return true;
    }
    return false;
  }

  static Future<bool> register(final String email, final String password, final String confirmPassword) async {
    if (password != confirmPassword) return false;

    final AppUser newUser = AppUser(email: email, password: password);
    final int result = await LocalDataService.registerUser(newUser);

    if (result != -1) {
      // Auto login after register
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserEmail, email);
      await prefs.setString(_keyUserName, 'User');
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all session data
  }
}
