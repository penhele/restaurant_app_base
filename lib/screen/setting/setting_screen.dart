import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/model/setting.dart';
import 'package:restaurant_app_base/provider/setting/dark_theme_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app_base/screen/setting/dark_theme_field_widget.dart';
import 'package:restaurant_app_base/screen/setting/save_button_widget.dart';
import 'package:restaurant_app_base/utils/dark_theme_state.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();

    final darkThemeStateProvider = context.read<DarkThemeStateProvider>();
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();

    Future.microtask(() async {
      sharedPreferencesProvider.getSettingValue();
      final setting = sharedPreferencesProvider.setting;

      if (setting != null) {
        darkThemeStateProvider.darkThemeState = setting.darkThemeEnable
            ? DarkThemeState.enable
            : DarkThemeState.disable;
      }
    });
  }

  void saveAction() async {
    final darkThemeState =
        context.read<DarkThemeStateProvider>().darkThemeState;
    final isDarkThemeEnable = darkThemeState.isEnable;

    final Setting setting = Setting(darkThemeEnable: isDarkThemeEnable);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
    await sharedPreferencesProvider.saveSettingValue(setting);

    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(sharedPreferencesProvider.message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DarkThemeField(),
                SaveButton(
                  onPressed: () => saveAction(),
                ),
              ],
            ),
          ),
        ));
  }
}
