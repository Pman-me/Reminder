part of 'set_notify_bloc.dart';

abstract class SetNotifyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetNotifyStarted extends SetNotifyEvent {}

class SetNotifySelectDateAndTimeClicked extends SetNotifyEvent {}

class SetNotifyReminderAddedEvent extends SetNotifyEvent {
  NotificationSchedulerModel notificationSchedulerModel;

  SetNotifyReminderAddedEvent({required this.notificationSchedulerModel});
}

class SetNotifyUpdatedEvent extends SetNotifyEvent {
  List<NotificationSchedulerModel> notificationSchedulers;

  SetNotifyUpdatedEvent({required this.notificationSchedulers});
}

class SetNotifyReminerDisabledEvent extends SetNotifyEvent {
  int notificationSchedulerIndex;

  SetNotifyReminerDisabledEvent({required this.notificationSchedulerIndex});
}

class SetNotifyDateAndTimeTakenEvent extends SetNotifyEvent {
  Jalali selectedJalaliDateTime;
  TimeOfDay endTimeOfDay;
  TimeOfDay startTimeOfDay;

  SetNotifyDateAndTimeTakenEvent(
      {required this.selectedJalaliDateTime,
      required this.endTimeOfDay,
      required this.startTimeOfDay});
}

class SetNotifyReminderCountTaken extends SetNotifyEvent{
  int reminderCount;

  SetNotifyReminderCountTaken({required this.reminderCount});
}
