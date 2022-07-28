import 'dart:typed_data';

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
    
    var vibrationPattern = Int64List(6);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 500;
    vibrationPattern[2] = 500;
    vibrationPattern[3] = 500;
    vibrationPattern[4] = 500;
    vibrationPattern[5] = 500;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        kNotificationChannelId,
        kNotificationChannelName,
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        vibrationPattern: vibrationPattern,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(kAlarmSoundName.split('.').first),
        enableLights: true,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}
