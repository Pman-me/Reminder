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
import '../../view/set_notify_screen/set_notify_view.dart';

part 'set_notify_event.dart';

part 'set_notify_state.dart';

class SetNotifyBloc extends Bloc<SetNotifyEvent, SetNotifyState> {
  final TextEditingController _controller = TextEditingController();
  Jalali? selectedJalaliDateTime;
  TimeOfDay? endTimeOfDay;
  TimeOfDay? startTimeOfDay;
  ObjectBoxHelper objectBoxHelper;
  late List<NotificationSchedulerModel> notificationSchedulers;

  SetNotifyBloc({required this.objectBoxHelper})
      : super(SetNotifyState(status: SetNotifyStatus.initial)) {
    on<SetNotifyStarted>(_onStarted);
    on<SetNotifySelectDateAndTimeClicked>(_onSelectDateAndTimeClicked);
    on<SetNotifyUpdated>(_onUpdated);
    on<SetNotifyDisabled>(_onDisabled);
  }

  _onStarted(SetNotifyStarted event, Emitter<SetNotifyState> emit) async {
    await objectBoxHelper.init();
    await Future.delayed(const Duration(milliseconds: 500));
    notificationSchedulers = objectBoxHelper.getDateAndTimes();
    emit(SetNotifyState(
        status: SetNotifyStatus.success,
        notificationSchedulersList: notificationSchedulers));
  }

  _onUpdated(SetNotifyUpdated event, Emitter<SetNotifyState> emit) {
    emit(SetNotifyState(
        status: SetNotifyStatus.update,
        notificationSchedulersList: event.notificationSchedulers));
  }

  _onDisabled(SetNotifyDisabled event, Emitter<SetNotifyState> emit) async {
    notificationSchedulers[event.notificationSchedulerIndex].isActive = false;
    add(SetNotifyUpdated(notificationSchedulers: notificationSchedulers));
    await Future.delayed(const Duration(milliseconds: 200));
    await cancelAlarmManager(
        alarmId: notificationSchedulers[event.notificationSchedulerIndex].id);
    objectBoxHelper.deleteTime(
        notificationSchedulers[event.notificationSchedulerIndex].id);
    notificationSchedulers.removeAt(event.notificationSchedulerIndex);
    add(SetNotifyUpdated(notificationSchedulers: notificationSchedulers));
  }

  _onSelectDateAndTimeClicked(SetNotifySelectDateAndTimeClicked event,
      Emitter<SetNotifyState> emit) async {
    await _getDateAndTimeFromUser(event.context);

    if (_isEndTimeOfDayAfterStartTimeOfDay()) {
      String? result =
          await openDialogEnterNotificationCount(event.context, _controller);
      if (result != null) {
        int count = int.parse(result);
        NotificationSchedulerModel notificationScheduler =
            await _generateRandomTimesAndSaveThem(count);
        debugPrint(DateTime.fromMillisecondsSinceEpoch(int.tryParse(
                notificationScheduler.dateTimesMillisecondsSinceEpoch.first)!)
            .toString());
        debugPrint(DateTime.now().millisecondsSinceEpoch.toString());
        await setAlarmManager(
            millisecondsSinceEpoch: int.tryParse(
                notificationScheduler.dateTimesMillisecondsSinceEpoch.first)!,
            alarmId: notificationScheduler.id);

        notificationSchedulers.add(notificationScheduler);
        add(SetNotifyUpdated(notificationSchedulers: notificationSchedulers));
      }
    } else {
      if (_checkNonNull()) {
        showSnackBar(event.context);
      }
    }
  }

  Future<void> _getDateAndTimeFromUser(BuildContext context) async {
    selectedJalaliDateTime = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1401, 4),
      lastDate: Jalali(1450, 12),
    );
    if (selectedJalaliDateTime == null) return;
    startTimeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTimeOfDay == null) return;

    TimeOfDay endTimeOfDayInitialTime =
        startTimeOfDay!.replacing(hour: startTimeOfDay!.hour + 1, minute: 0);

    endTimeOfDay = await showTimePicker(
      context: context,
      initialTime: endTimeOfDayInitialTime,
    );
  }

  Future<NotificationSchedulerModel> _generateRandomTimesAndSaveThem(
      int count) async {
    Random random = Random();

    double doubleEndToMinute =
        endTimeOfDay!.hour.toDouble() + (endTimeOfDay!.minute.toDouble() / 60);
    double doubleStarToMinute = startTimeOfDay!.hour.toDouble() +
        (startTimeOfDay!.minute.toDouble() / 60);

    double interval = (doubleEndToMinute - doubleStarToMinute);

    Set<double> generatedRandomMinutesSet = <double>{};
    while (generatedRandomMinutesSet.length < count) {
      double randomTimeOfDay = random.nextDouble() * interval;
      if (randomTimeOfDay > (kMinimumTimeInterval / 60)) {
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
                  selectedJalaliDateTime!.toDateTime().year,
                  selectedJalaliDateTime!.toDateTime().month,
                  selectedJalaliDateTime!.toDateTime().day,
                  startTimeOfDay!.hour + hour,
                  startTimeOfDay!.minute + minute)
              .millisecondsSinceEpoch)
          .toString());
    }

    DateTime notificationSchedulerId = DateTime(
        selectedJalaliDateTime!.toDateTime().year,
        selectedJalaliDateTime!.toDateTime().month,
        selectedJalaliDateTime!.toDateTime().day,
        0,
        0);

    DateTime startDateTime = DateTime(
        selectedJalaliDateTime!.toDateTime().year,
        selectedJalaliDateTime!.toDateTime().month,
        selectedJalaliDateTime!.toDateTime().day,
        startTimeOfDay!.hour,
        startTimeOfDay!.minute);

    DateTime endDateTime = DateTime(
        selectedJalaliDateTime!.toDateTime().year,
        selectedJalaliDateTime!.toDateTime().month,
        selectedJalaliDateTime!.toDateTime().day,
        endTimeOfDay!.hour,
        endTimeOfDay!.minute);

    NotificationSchedulerModel notificationSchedulerModel =
        NotificationSchedulerModel(
            id: notificationSchedulerId.millisecondsSinceEpoch,
            dateTimesMillisecondsSinceEpoch: millisecondSinceEpoch,
            startDateTime: startDateTime,
            endDateTime: endDateTime);

    objectBoxHelper.put(notificationSchedulerModel);
    return notificationSchedulerModel;
  }

  bool _checkNonNull() =>
      selectedJalaliDateTime != null &&
      startTimeOfDay != null &&
      endTimeOfDay != null;

  bool _isEndTimeOfDayAfterStartTimeOfDay() {
    return (_checkNonNull() && endTimeOfDay!.isAfter(startTimeOfDay!));
  }

  @override
  Future<void> close() {
    _controller.dispose();
    objectBoxHelper.close();
    return super.close();
  }
}
