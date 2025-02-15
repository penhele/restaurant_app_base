import 'package:flutter/material.dart';
import 'package:restaurant_app_base/data/model/restaurant_detail.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'restaurantlist.db';
  static const String _tableName = 'restaurant';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
      """
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        city TEXT,
        address TEXT,
        pictureId TEXT,
        categories TEXT,
        menus TEXT,      
        rating REAL,
        customerReviews TEXT 
      )
    """,
    );
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(RestaurantDetail restaurant) async {
    try {
      final db = await _initializeDb();
      final data = restaurant.toJson();
      final id = await db.insert(
        _tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("Inserted item ID: $id");
      return id;
    } catch (e) {
      debugPrint("Failed to insert item: $e");
      throw Exception("Failed to insert item: $e");
    }
  }

  Future<List<RestaurantDetail>> getAllItems() async {
    try {
      final db = await _initializeDb();
      final results = await db.query(_tableName, orderBy: "id");

      return results
          .map((result) => RestaurantDetail.fromJson(result))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch items: $e");
    }
  }

  Future<RestaurantDetail> getItemById(String id) async {
    final db = await _initializeDb();
    final results =
        await db.query(_tableName, where: "id = ?", whereArgs: [id], limit: 1);

    return results.map((result) => RestaurantDetail.fromJson(result)).first;
  }

  Future<int> removeItem(String id) async {
    final db = await _initializeDb();

    final result =
        await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }
}
