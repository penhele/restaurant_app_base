import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/model/setting.dart';
import 'package:restaurant_app_base/provider/setting/dark_theme_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app_base/screen/setting/title_form_widget.dart';
import 'package:restaurant_app_base/utils/notification_state.dart';

class NotificationField extends StatefulWidget {
  const NotificationField({super.key});

  @override
  State<NotificationField> createState() => _NotificationFieldState();
}

class _NotificationFieldState extends State<NotificationField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleForm(
            'Daily Reminder:',
          ),
          const SizedBox.square(dimension: 4),
          Consumer<NotificationStateProvider>(
            builder: (_, provider, __) {
              final isNotificationDisabled =
                  provider.notificationState == NotificationState.disable;
              final localNotificationProvider =
                  context.read<LocalNotificationProvider>();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable Reminder'),
                  Switch(
                    value: isNotificationDisabled,
                    onChanged: (value) async {
                      final isPermissionGranted =
                          await localNotificationProvider
                              .checkNotificationPermission();

                      if (!isPermissionGranted && value) {
                        await _requestPermission();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please enable notification permissions in settings.'),
                          ),
                        );
                        return;
                      }

                      provider.notificationState = !value
                          ? NotificationState.enable
                          : NotificationState.disable;

                      if (!value) {
                        localNotificationProvider
                            .scheduleDailyElevenAMNotification();
                      } else {
                        localNotificationProvider.clearAllNotifications();
                      }

                      saveAction();
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

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  void saveAction() async {
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
