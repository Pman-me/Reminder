part of 'set_reminder_bloc.dart';

abstract class SetReminderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetReminderStarted extends SetReminderEvent {}

class SetReminderSelectDateAndTimeClicked extends SetReminderEvent {}

class SetReminderAddedEvent extends SetReminderEvent {
  NotificationSchedulerModel notificationSchedulerModel;

  SetReminderAddedEvent({required this.notificationSchedulerModel});
}

class SetReminderUpdatedEvent extends SetReminderEvent {
  List<NotificationSchedulerModel> notificationSchedulers;

  SetReminderUpdatedEvent({required this.notificationSchedulers});
}

class SetReminderDisabledEvent extends SetReminderEvent {
  int notificationSchedulerIndex;

  SetReminderDisabledEvent({required this.notificationSchedulerIndex});
}

class SetReminderDateAndTimeTakenEvent extends SetReminderEvent {
  Jalali selectedJalaliDateTime;
  TimeOfDay endTimeOfDay;
  TimeOfDay startTimeOfDay;

  SetReminderDateAndTimeTakenEvent(
      {required this.selectedJalaliDateTime,
      required this.endTimeOfDay,
      required this.startTimeOfDay});
}

class SetReminderCountAndNotificationTitleTaken extends SetReminderEvent{
  int reminderCount;
  String notificationTitle;

  SetReminderCountAndNotificationTitleTaken({required this.reminderCount,required this.notificationTitle});
}
