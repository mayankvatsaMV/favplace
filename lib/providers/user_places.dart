import 'dart:io';

import 'package:favplaces/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import '../models/place.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT,cat TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) {
      final catValue = row['cat'];
      print("category is " + catValue.toString());
      return Place(
          id: row["id"] as String,
          title: row['title'] as String,
          image: File(row['image'] as String),
          location: PlaceLocation(
            latitude: row["lat"] as double,
            longitude: row["lng"] as double,
            address: row['address'] as String,
          ),
          cat: row['cat'] as String
          // cat:category.Entertainment

          );
    }).toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location,String cat) async {
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    // final fileName = path.basename(image.path);
    // print(fileName);
    // final copiedImg = await image.copy('${appDir.path}/${fileName}');
    // final newPlace = Place(title: title, image: copiedImg, location: location);
    final newPlace =
        Place(title: title, image: image, location: location, cat: cat);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
      'cat':newPlace.cat
    });
    print("done");
    state = [...state, newPlace];
  }

  void updateDataBase(String id, String name) async {
    final db = await _getDatabase();
    print(name);
    db.delete('user_places', where: 'id= ?', whereArgs: [id]);
  }
}

final userplaceProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
