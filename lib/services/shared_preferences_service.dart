import 'package:restaurant_app_base/data/model/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keyDarkTheme = "MYDARKTHEME";
  static const String keyNotification = "MYNOTIFICATION";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(keyDarkTheme, setting.darkThemeEnable);
      await _preferences.setBool(keyNotification, setting.notificationEnable);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Setting getSettingValue() {
    return Setting(
      darkThemeEnable: _preferences.getBool(keyDarkTheme) ?? true,
      notificationEnable: _preferences.getBool(keyNotification) ?? true,
    );
  }
}
