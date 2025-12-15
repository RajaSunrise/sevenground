import 'db_abstract.dart';
import 'db_mobile.dart' if (dart.library.html) 'db_web.dart';

class DatabaseHelperFactory {
  static DatabaseHelper getHelper() {
    return DatabaseHelperImpl();
  }
}
