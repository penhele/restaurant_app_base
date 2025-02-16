import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
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
              final isNotificationEnabled =
                  provider.notificationState == NotificationState.enable;
              final localNotificationProvider =
                  context.read<LocalNotificationProvider>();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable Reminder'),
                  Switch(
                    value: isNotificationEnabled,
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

                      provider.notificationState = value
                          ? NotificationState.enable
                          : NotificationState.disable;

                      if (value) {
                        localNotificationProvider
                            .scheduleDailyElevenAMNotification();
                      } else {
                        localNotificationProvider.clearAllNotifications();
                      }
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
}
