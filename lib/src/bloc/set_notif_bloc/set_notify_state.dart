part of 'set_notify_bloc.dart';

enum SetNotifyStatus{initial,success,update}

class SetNotifyState  {

  SetNotifyStatus status;
  List<NotificationSchedulerModel> notificationSchedulersList;

  SetNotifyState({required this.status, this.notificationSchedulersList = const[]});

}
