import 'package:Reminder/src/service/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'life_cycle.dart';



void main() {
  _startSetup();
  runApp(LifeCycle(
    child: NotifyMeApp(),
  ));
}

Future<void> _startSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await AndroidAlarmManager.initialize();
}
