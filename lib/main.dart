import 'package:Reminder/src/core/constants/general_constant.dart';
import 'package:Reminder/src/core/util/extensions.dart';
import 'package:Reminder/src/service/notification_service.dart';
import 'package:Reminder/src/data/model/notification_scheduler_model.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'life_cycle.dart';
import 'src/data/local/object_box_helper.dart';
import 'src/service/alarm_manager.dart';

Future<void> callbackDispatcher() async {
  late NotificationSchedulerModel notificationScheduler;
  try {
    ObjectBoxHelper objectBox = ObjectBoxHelper();
    await objectBox.init();
    List notificationSchedulers =
        objectBox.getDateAndTimes();

    for (int i = 0; i < notificationSchedulers.length; i++) {
      int notificationSchedulersId = notificationSchedulers[i].id;
      if (DateTime.now().isAtSameDayAs(
          DateTime.fromMillisecondsSinceEpoch(notificationSchedulersId))) {
        notificationScheduler = notificationSchedulers[i];
        break;
      }
    }
    NotificationService.showNotification(
        notificationId: kNotificationId, title: "یاد آوری");

    notificationScheduler.dateTimesMillisecondsSinceEpoch.removeAt(0);
    objectBox.put(notificationScheduler);
    if (notificationScheduler.dateTimesMillisecondsSinceEpoch.isNotEmpty) {
      await setAlarmManager(
          millisecondsSinceEpoch: int.tryParse(
              notificationScheduler.dateTimesMillisecondsSinceEpoch.first)!,alarmId: notificationScheduler.id);
    } else {
      objectBox.deleteTime(notificationScheduler.id);
    }
    objectBox.close();
  } catch (err) {
    throw Exception(err);
  }
}

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
