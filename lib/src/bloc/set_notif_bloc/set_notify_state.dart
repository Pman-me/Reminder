part of 'set_notify_bloc.dart';

abstract class SetNotifyState {
  late List<NotificationSchedulerModel> notificationSchedulersList;
}

class SetNotifyInitial extends SetNotifyState {}

class SetNotifySuccess extends SetNotifyState {
  @override
  List<NotificationSchedulerModel> notificationSchedulersList;

  SetNotifySuccess({required this.notificationSchedulersList});
}

class SetNotifyUpdate extends SetNotifyState {
  @override
  List<NotificationSchedulerModel> notificationSchedulersList;

  SetNotifyUpdate({required this.notificationSchedulersList});
}

class SetNotifyShowEnterNotificationCountDialog extends SetNotifyState {
  final textEditingController;

  SetNotifyShowEnterNotificationCountDialog(
      {required this.textEditingController});
}

class SetNotifyShowDateAndTimePicker extends SetNotifyState {}

class SetNotifyShowSnackBar extends SetNotifyState {}
