import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:notify_me/life_cycle.dart';
import 'package:notify_me/src/core/constants/general_constant.dart';
import 'package:notify_me/src/core/helper/alarm_manager.dart';
import 'package:notify_me/src/core/util/extensions.dart';
import 'package:notify_me/src/core/util/notification_api.dart';
import 'package:notify_me/src/data/model/notification_scheduler_model.dart';

import 'app.dart';
import 'src/data/local/object_box_helper.dart';

Future<void> callbackDispatcher() async {
  late NotificationSchedulerModel notificationScheduler;
  try {
    ObjectBoxHelper objectBox = ObjectBoxHelper();
    await objectBox.init();
    List<NotificationSchedulerModel> notificationSchedulers =
        objectBox.getDateAndTimes();

    for (int i = 0; i < notificationSchedulers.length; i++) {
      int notificationSchedulersId = notificationSchedulers[i].id;
      if (DateTime.now().isAtSameDayAs(
          DateTime.fromMillisecondsSinceEpoch(notificationSchedulersId))) {
        notificationScheduler = notificationSchedulers[i];
        break;
      }
    }
    NotificationApi.showNotification(
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
  await NotificationApi.init();
  await AndroidAlarmManager.initialize();
}
