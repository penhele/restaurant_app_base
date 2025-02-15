import 'package:flutter/material.dart';
import 'package:restaurant_app_base/data/model/restaurant_detail.dart';
import 'package:restaurant_app_base/services/sqlite_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqliteService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<RestaurantDetail> _restaurantList = [];
  List<RestaurantDetail> get restaurantList => _restaurantList;

  RestaurantDetail? _restaurant;
  RestaurantDetail? get restaurant => _restaurant;

  Future<void> saveRestaurantValue(RestaurantDetail value) async {
    try {
      final result = await _service.insertItem(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
        notifyListeners();
      } else {
        _message = "Your data is saved";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      notifyListeners();
    }
  }

  Future<void> loadAllRestaurantValue() async {
    try {
      _restaurantList = await _service.getAllItems();
      _message = "All of your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your all data";
      notifyListeners();
    }
  }

  Future<void> loadRestaurantValueById(String id) async {
    try {
      _restaurant = await _service.getItemById(id);
      _message = "Your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your data";
      notifyListeners();
    }
  }

  Future<void> removeRestaurantValueById(String id) async {
    try {
      await _service.removeItem(id);
      _message = "Your data is removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }

  bool checkItemFavorite(String id) {
    try {
      return _restaurantList.any((restaurant) => restaurant.id == id);
    } catch (e) {
      debugPrint("Error checking favorite status: $e");
      return false;
    }
  }
}
