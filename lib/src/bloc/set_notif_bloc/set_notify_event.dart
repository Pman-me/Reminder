part of 'set_notify_bloc.dart';

abstract class SetNotifyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetNotifyStarted extends SetNotifyEvent{}

class SetNotifySelectDateAndTimeClicked extends SetNotifyEvent {
  BuildContext context;

  SetNotifySelectDateAndTimeClicked(this.context);
}

class SetNotifyAdded extends SetNotifyEvent{
  NotificationSchedulerModel notificationSchedulerModel;

  SetNotifyAdded({required this.notificationSchedulerModel});
}
class SetNotifyUpdated extends SetNotifyEvent{
  List<NotificationSchedulerModel> notificationSchedulers;

  SetNotifyUpdated({required this.notificationSchedulers});
}

class SetNotifyDisabled extends SetNotifyEvent{
  int notificationSchedulerIndex;

  SetNotifyDisabled({required this.notificationSchedulerIndex});
}
