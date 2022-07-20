import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/constants/general_constant.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init() async {
    final android = AndroidInitializationSettings('alarm');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);
  }

  static Future showNotification({
    required int notificationId,
    required String title,
    String? body,
    String? payload,
  }) async {
    return _notifications.show(
      notificationId,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        kNotificationChannelId,
        kNotificationChannelName,
        importance: Importance.defaultImportance,
        enableVibration: true,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}
