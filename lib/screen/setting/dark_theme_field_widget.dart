import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/model/setting.dart';
import 'package:restaurant_app_base/provider/setting/dark_theme_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app_base/screen/setting/title_form_widget.dart';
import 'package:restaurant_app_base/utils/dark_theme_state.dart';

class DarkThemeField extends StatelessWidget {
  const DarkThemeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleForm(
            'Dark Theme:',
          ),
          const SizedBox.square(dimension: 4),
          Consumer<DarkThemeStateProvider>(
            builder: (_, provider, __) {
              final isDarkModeDisabled =
                  provider.darkThemeState == DarkThemeState.disable;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable Dark Theme'),
                  Switch(
                    value: isDarkModeDisabled,
                    onChanged: (value) {
                      provider.darkThemeState = !value
                          ? DarkThemeState.enable
                          : DarkThemeState.disable;
                      saveAction(context);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void saveAction(BuildContext context) async {
    final darkThemeState =
        context.read<DarkThemeStateProvider>().darkThemeState;
    final notificationState =
        context.read<NotificationStateProvider>().notificationState;
    final isDarkThemeEnable = darkThemeState.isEnable;
    final isNotificationEnable = notificationState.isEnable;

    final Setting setting = Setting(
        darkThemeEnable: isDarkThemeEnable,
        notificationEnable: isNotificationEnable);

    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();
    await sharedPreferencesProvider.saveSettingValue(setting);
  }
}
