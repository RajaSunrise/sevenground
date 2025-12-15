import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/place.dart';
import '../model/order_model.dart';
import '../model/user_model.dart';
import 'db_abstract.dart';

class DatabaseHelperImpl implements DatabaseHelper {
  static Database? _db;
  static const String _tblPlaces = 'places';
  static const String _tblOrders = 'orders';
  static const String _tblUsers = 'users';

  @override
  Future<void> init() async {
    if (_db != null) return;
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = join(dir.path, 'sevenground.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (final Database db, final int version) async {
        await db.execute('''
          CREATE TABLE $_tblPlaces (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            location TEXT,
            image TEXT,
            description TEXT,
            category TEXT,
            elevation INTEGER,
            rating INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE $_tblOrders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            placeName TEXT,
            date TEXT,
            pax INTEGER,
            totalPrice INTEGER,
            status TEXT,
            paymentMethod TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $_tblUsers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            name TEXT
          )
        ''');

        // Seed initial data
        await db.insert(_tblPlaces, {
          'name': 'Gunung Rinjani',
          'location': 'Lombok',
          'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
          'description': 'Gunung tertinggi di Lombok',
          'category': 'mountain',
          'elevation': 3726,
          'rating': 5,
        });
        await db.insert(_tblPlaces, {
           'name': 'Pantai Tanjung Aan',
          'location': 'Lombok',
          'image': 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
          'description': 'Pantai cantik dengan pasir putih',
          'category': 'beach',
          'elevation': 0,
          'rating': 4,
        });
      },
    );
  }

  Future<Database> get db async {
    if (_db == null) await init();
    return _db!;
  }

  // ====================== PLACES ======================

  @override
  Future<List<Place>> getPlaces() async {
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.query(_tblPlaces);
    return List.generate(maps.length, (final i) => Place.fromMap(maps[i]));
  }

  @override
  Future<int> insertPlace(final Place place) async {
    final Database database = await db;
    return await database.insert(_tblPlaces, place.toMap());
  }

  @override
  Future<int> updatePlace(final Place place) async {
    final Database database = await db;
    return await database.update(
      _tblPlaces,
      place.toMap(),
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  @override
  Future<int> deletePlace(final int id) async {
    final Database database = await db;
    return await database.delete(
      _tblPlaces,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ====================== ORDERS ======================

  @override
  Future<List<OrderTrip>> getOrders() async {
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.query(_tblOrders);
    return List.generate(maps.length, (final i) => OrderTrip.fromMap(maps[i]));
  }

  @override
  Future<int> insertOrder(final OrderTrip order) async {
    final Database database = await db;
    return await database.insert(_tblOrders, order.toMap());
  }

  // ====================== USERS ======================

  @override
  Future<int> registerUser(final AppUser user) async {
    final Database database = await db;
    try {
      return await database.insert(_tblUsers, user.toMap());
    } catch (e) {
      return -1; // User exists or error
    }
  }

  @override
  Future<AppUser?> loginUser(final String email, final String password) async {
    final Database database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      _tblUsers,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return AppUser.fromMap(maps.first);
    }
    return null;
  }
}
