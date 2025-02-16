import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
import 'package:restaurant_app_base/screen/setting/title_form_widget.dart';
import 'package:restaurant_app_base/utils/notification_state.dart';

class NotificationField extends StatelessWidget {
  const NotificationField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleForm(
            'Notification:',
          ),
          const SizedBox.square(dimension: 4),
          Consumer<NotificationStateProvider>(
            builder: (_, provider, __) {
              final isNotificationEnabled =
                  provider.notificationState == NotificationState.enable;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable Dark Theme'),
                  Switch(
                    value: isNotificationEnabled,
                    onChanged: (value) {
                      provider.notificationState = value
                          ? NotificationState.enable
                          : NotificationState.disable;
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
}
