import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


import '../../../main.dart';

Future setAlarmManager({required int millisecondsSinceEpoch,required int alarmId}) async{
  await AndroidAlarmManager.oneShotAt(
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch),
      alarmId,
      callbackDispatcher,
      exact: false,
      wakeup: true,
      rescheduleOnReboot: true);
}

Future cancelAlarmManager({required int alarmId}) async{
  await AndroidAlarmManager.cancel(alarmId);
}

