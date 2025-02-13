import 'package:flutter/material.dart';
import 'package:restaurant_app_base/utils/dark_theme_state.dart';

class DarkThemeStateProvider extends ChangeNotifier {
  DarkThemeState _darkThemeState = DarkThemeState.system;

  DarkThemeState get darkThemeState => _darkThemeState;

  set darkThemeState(DarkThemeState value) {
    _darkThemeState = value;
    notifyListeners();
  }
}
