import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_base/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void scheduleDailyElevenAMNotification() {
    _notificationId += 1;
    flutterNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
    );
  }

  Future<bool> checkNotificationPermission() async {
    if (_permission == null) {
      _permission = await flutterNotificationService.requestPermissions();
      notifyListeners();
    }
    return _permission ?? false;
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> clearAllNotifications() async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();
    for (final notification in pendingNotificationRequests) {
      await notificationPlugin.cancel(notification.id);
    }
    pendingNotificationRequests.clear();
    notifyListeners();
  }
}
