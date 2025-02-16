import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/model/setting.dart';
import 'package:restaurant_app_base/provider/setting/dark_theme_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app_base/screen/setting/dark_theme_field_widget.dart';
import 'package:restaurant_app_base/screen/setting/notification_field_widget.dart';
import 'package:restaurant_app_base/screen/setting/save_button_widget.dart';
import 'package:restaurant_app_base/utils/dark_theme_state.dart';
import 'package:restaurant_app_base/utils/notification_state.dart';

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
    final notificationStateProvider = context.read<NotificationStateProvider>();
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();

    Future.microtask(() async {
      sharedPreferencesProvider.getSettingValue();
      final setting = sharedPreferencesProvider.setting;

      if (setting != null) {
        darkThemeStateProvider.darkThemeState = setting.darkThemeEnable
            ? DarkThemeState.enable
            : DarkThemeState.disable;
        notificationStateProvider.notificationState = setting.notificationEnable
            ? NotificationState.enable
            : NotificationState.disable;
      }
    });
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
                const NotificationField(),
                SaveButton(
                  onPressed: () => saveAction(),
                ),

                // untuk mengetahui permission dan notifikasi aktif atau tidak
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _requestPermission();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(175, 50),
                      ),
                      child: Consumer<LocalNotificationProvider>(
                        builder: (context, value, child) {
                          return Text(
                            "Permission : (${value.permission})",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _checkPendingNotificationRequests();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(175, 50),
                      ),
                      child: Text(
                        "Check pending",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _checkPendingNotificationRequests() async {
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    await localNotificationProvider.checkPendingNotificationRequests(context);

    if (!mounted) {
      return;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final pendingData = context.select(
            (LocalNotificationProvider provider) =>
                provider.pendingNotificationRequests);
        return AlertDialog(
          title: Text(
            pendingData.isEmpty
                ? 'There is no reminder'
                : 'Pending notification requests',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 200,
            width: 300,
            child: ListView.builder(
              itemCount: pendingData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = pendingData[index];
                return ListTile(
                  title: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.body ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
