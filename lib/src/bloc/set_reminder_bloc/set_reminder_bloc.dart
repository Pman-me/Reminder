import 'dart:async';
import 'dart:math';
import 'package:Reminder/src/core/util/extensions.dart';
import 'package:Reminder/src/service/alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/general_constant.dart';
import '../../data/local/object_box_helper.dart';
import '../../data/model/notification_scheduler_model.dart';

part 'set_reminder_event.dart';

part 'set_reminder_state.dart';

class SetReminderBloc extends Bloc<SetReminderEvent, SetReminderState> {
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  late Jalali selectedJalaliDateTime;
  late TimeOfDay endTimeOfDay;
  late TimeOfDay startTimeOfDay;
  ObjectBoxHelper objectBoxHelper;
  late List<NotificationSchedulerModel> notificationSchedulers;

  SetReminderBloc({required this.objectBoxHelper}) : super(SetReminderInitial()) {
    on<SetReminderStarted>(_onStarted);
    on<SetReminderSelectDateAndTimeClicked>(_onSelectDateAndTimeClicked);
    on<SetReminderUpdatedEvent>(_onUpdated);
    on<SetReminderDisabledEvent>(_onDisabled);
    on<SetReminderDateAndTimeTakenEvent>(_onDateAndTimeTaken);
    on<SetReminderCountAndNotificationTitleTaken>(
        _onReminderCountAndNotificationTitleTaken);
  }

  _onStarted(SetReminderStarted event, Emitter<SetReminderState> emit) async {
    await objectBoxHelper.init();
    await Future.delayed(const Duration(milliseconds: 500));
    notificationSchedulers = objectBoxHelper.getDateAndTimes();
    emit(SetReminderSuccess(notificationSchedulersList: notificationSchedulers));
  }

  _onUpdated(SetReminderUpdatedEvent event, Emitter<SetReminderState> emit) {
    emit(SetReminderUpdate(
        notificationSchedulersList: event.notificationSchedulers));
  }

  _onDisabled(
      SetReminderDisabledEvent event, Emitter<SetReminderState> emit) async {
    notificationSchedulers[event.notificationSchedulerIndex].isActive = false;
    add(SetReminderUpdatedEvent(notificationSchedulers: notificationSchedulers));
    await Future.delayed(const Duration(milliseconds: 200));
    await cancelAlarmManager(
        alarmId: notificationSchedulers[event.notificationSchedulerIndex].id);
    objectBoxHelper.deleteTime(
        notificationSchedulers[event.notificationSchedulerIndex].id);
    notificationSchedulers.removeAt(event.notificationSchedulerIndex);
    add(SetReminderUpdatedEvent(notificationSchedulers: notificationSchedulers));
  }

  _onSelectDateAndTimeClicked(SetReminderSelectDateAndTimeClicked event,
      Emitter<SetReminderState> emit) async {
    emit(SetReminderShowDateAndTimePicker());
  }

  _onDateAndTimeTaken(
      SetReminderDateAndTimeTakenEvent event, Emitter<SetReminderState> emit) {
    selectedJalaliDateTime = event.selectedJalaliDateTime;
    startTimeOfDay = event.startTimeOfDay;
    endTimeOfDay = event.endTimeOfDay;

    if (_isEndTimeOfDayAfterStartTimeOfDay(
        selectedJalaliDateTime, startTimeOfDay, endTimeOfDay)) {
      emit(SetReminderShowEnterNotificationCountAndTitleDialog(
          countController: _countController,notificationTitle: _titleController));
    } else {
      emit(SetReminderShowSnackBar());
    }
  }

  _onReminderCountAndNotificationTitleTaken(
      SetReminderCountAndNotificationTitleTaken event,
      Emitter<SetReminderState> emit) async {
    NotificationSchedulerModel notificationScheduler =
        await _generateRandomTimes(
            event.reminderCount, event.notificationTitle);

    _saveNotificationScheduler(notificationScheduler);

    await setAlarmManager(
        millisecondsSinceEpoch: int.tryParse(
            notificationScheduler.dateTimesMillisecondsSinceEpoch.first)!,
        alarmId: notificationScheduler.id);

    notificationSchedulers.add(notificationScheduler);
    add(SetReminderUpdatedEvent(notificationSchedulers: notificationSchedulers));
  }

  bool _isEndTimeOfDayAfterStartTimeOfDay(Jalali selectedJalaliDateTime,
      TimeOfDay startTimeOfDay, TimeOfDay endTimeOfDay) {
    return endTimeOfDay.isAfter(startTimeOfDay);
  }

  Future<NotificationSchedulerModel> _generateRandomTimes(
      int reminderCount, String notificationTitle) async {
    Random random = Random();

    double doubleEndToMinute =
        endTimeOfDay.hour.toDouble() + (endTimeOfDay.minute.toDouble() / 60);
    double doubleStarToMinute = startTimeOfDay.hour.toDouble() +
        (startTimeOfDay.minute.toDouble() / 60);

    double interval = (doubleEndToMinute - doubleStarToMinute);

    Set<double> generatedRandomMinutesSet = <double>{};
    while (generatedRandomMinutesSet.length < reminderCount) {
      double randomTimeOfDay = random.nextDouble() * interval;
      if (randomTimeOfDay > (kMinimumInterval / 60)) {
        generatedRandomMinutesSet.add(randomTimeOfDay);
      }
    }

    //convert set to list for sort
    List<double> generatedRandomMinutesList =
        generatedRandomMinutesSet.toList();
    generatedRandomMinutesList.sort();

    //create list for convert generated random values to dateTime
    List<String> millisecondSinceEpoch = [];

    for (int i = 0; i < generatedRandomMinutesList.length; i++) {
      int hour = (generatedRandomMinutesList[i]).truncate();
      int minute = ((generatedRandomMinutesList[i] - hour) * 60).toInt();

      millisecondSinceEpoch.add((DateTime(
                  selectedJalaliDateTime.toDateTime().year,
                  selectedJalaliDateTime.toDateTime().month,
                  selectedJalaliDateTime.toDateTime().day,
                  startTimeOfDay.hour + hour,
                  startTimeOfDay.minute + minute)
              .millisecondsSinceEpoch)
          .toString());
    }

    DateTime notificationSchedulerId = DateTime(
        selectedJalaliDateTime.toDateTime().year,
        selectedJalaliDateTime.toDateTime().month,
        selectedJalaliDateTime.toDateTime().day,
        0,
        0);

    DateTime startDateTime = DateTime(
        selectedJalaliDateTime.toDateTime().year,
        selectedJalaliDateTime.toDateTime().month,
        selectedJalaliDateTime.toDateTime().day,
        startTimeOfDay.hour,
        startTimeOfDay.minute);

    DateTime endDateTime = DateTime(
        selectedJalaliDateTime.toDateTime().year,
        selectedJalaliDateTime.toDateTime().month,
        selectedJalaliDateTime.toDateTime().day,
        endTimeOfDay.hour,
        endTimeOfDay.minute);

    NotificationSchedulerModel notificationScheduler =
        NotificationSchedulerModel(
            id: notificationSchedulerId.millisecondsSinceEpoch ~/ 10000,
            dateTimesMillisecondsSinceEpoch: millisecondSinceEpoch,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            notificationTitle: notificationTitle);

    return notificationScheduler;
  }

  void _saveNotificationScheduler(
      NotificationSchedulerModel notificationScheduler) {
    objectBoxHelper.put(notificationScheduler);
  }

  @override
  Future<void> close() {
    _countController.dispose();
    objectBoxHelper.close();
    return super.close();
  }
}
