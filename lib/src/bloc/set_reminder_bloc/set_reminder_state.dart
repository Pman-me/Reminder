part of 'set_reminder_bloc.dart';

abstract class SetReminderState {
  late List<NotificationSchedulerModel> notificationSchedulersList;
}

class SetReminderInitial extends SetReminderState {}

class SetReminderSuccess extends SetReminderState {
  @override
  List<NotificationSchedulerModel> notificationSchedulersList;

  SetReminderSuccess({required this.notificationSchedulersList});
}

class SetReminderUpdate extends SetReminderState {
  @override
  List<NotificationSchedulerModel> notificationSchedulersList;

  SetReminderUpdate({required this.notificationSchedulersList});
}

class SetReminderShowEnterNotificationCountAndTitleDialog extends SetReminderState {
  final countController;
  final notificationTitle;

  SetReminderShowEnterNotificationCountAndTitleDialog(
      {required this.countController,required this.notificationTitle});
}

class SetReminderShowDateAndTimePicker extends SetReminderState {}

class SetReminderShowSnackBar extends SetReminderState {}
