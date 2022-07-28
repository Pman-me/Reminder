import 'package:Reminder/src/bloc/set_reminder_bloc/set_reminder_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../gen/assets.gen.dart';
import '../../configs/app_theme.dart';
import '../../core/constants/general_constant.dart';
import '../../data/local/object_box_helper.dart';
import '../../data/model/notification_scheduler_model.dart';
import '../components/nil.dart';

class SetReminderScreen extends StatelessWidget {
  SetReminderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetReminderBloc(
          objectBoxHelper: RepositoryProvider.of<ObjectBoxHelper>(context))
        ..add(SetReminderStarted()),
      child: BlocBuilder<SetReminderBloc, SetReminderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const _SetNotifyAppbar(),
            body: _SetNotifyBody(),
            floatingActionButton:  (state is SetReminderInitial)? Nil(): const _SetNotifyFab(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

class _SetNotifyBody extends StatelessWidget {
  const _SetNotifyBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetReminderBloc, SetReminderState>(
        buildWhen: (previous, current) {
      if (current is SetReminderShowEnterNotificationCountAndTitleDialog ||
          current is SetReminderShowDateAndTimePicker ||
          current is SetReminderShowSnackBar) {
        return false;
      } else {
        return true;
      }
    }, builder: (context, state) {
      late Widget result;
      if (state is SetReminderInitial) {
        result = _initialView();
      }
      if (state is SetReminderSuccess || state is SetReminderUpdate) {
        if (state.notificationSchedulersList.isNotEmpty) {
          var notificationSchedulerList = state.notificationSchedulersList;
          result = _successView(notificationSchedulerList);
        } else {
          result = _emptyView();
        }
      }

      return result;
    }, listener: (context, state) {
      if (state is SetReminderShowSnackBar) {
        _showSnackBar(context);
      }
      if (state is SetReminderShowDateAndTimePicker) {
        _getDateAndTimeFromUser(context);
      }
      if(state is SetReminderShowEnterNotificationCountAndTitleDialog){
        _openEnterReminderCountDialog(context,state.countController,state.notificationTitle);
      }
    });
  }

  Widget _initialView() {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        LinearProgressIndicator(
          backgroundColor: lightTheme.colorScheme.onPrimary,
          valueColor: AlwaysStoppedAnimation(lightTheme.colorScheme.primary),
          minHeight: 2,
        )
      ],
    );
  }

  Widget _successView(
      List<NotificationSchedulerModel> notificationSchedulerList) {
    return ListView.builder(
        itemCount: notificationSchedulerList.length,
        itemBuilder: (context, index) {
          NotificationSchedulerModel notificationScheduler =
              notificationSchedulerList[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  notificationScheduler.startDateTime
                      .toJalali()
                      .formatFullDate(),
                  style: lightTheme.textTheme.headline6!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                subtitle: Text(
                  localization!.notificationCount +
                      notificationScheduler
                          .dateTimesMillisecondsSinceEpoch.length
                          .toString(),
                  style: lightTheme.textTheme.caption!.copyWith(fontSize: 16),
                ),
                trailing: CupertinoSwitch(
                  activeColor: lightTheme.colorScheme.primary,
                  value: notificationScheduler.isActive,
                  onChanged: (value) {
                    context.read<SetReminderBloc>().add(
                        SetReminderDisabledEvent(
                            notificationSchedulerIndex: index));
                  },
                ),
              ),
              Divider(
                height: 2,
                color: lightTheme.colorScheme.onSurface,
                indent: 16,
                endIndent: 16,
              )
            ],
          );
        });
  }

  Widget _emptyView() {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.empty.svg(width: 150, height: 150),
          SizedBox(
            height: 8,
          ),
          Text(
            localization!.empty,
            style: lightTheme.textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}

class _SetNotifyFab extends StatelessWidget {
  const _SetNotifyFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.ltr,
      child: FloatingActionButton.extended(
        backgroundColor: lightTheme.colorScheme.primary,
        label: Text(
          localization!.selectTime,
          style: lightTheme.textTheme.bodyText1!
              .apply(color: lightTheme.colorScheme.onPrimary),
        ),
        icon: Icon(
          Icons.more_time,
          color: lightTheme.colorScheme.onPrimary,
        ),
        onPressed: () {
          context
              .read<SetReminderBloc>()
              .add(SetReminderSelectDateAndTimeClicked());
        },
      ),
    );
  }
}

class _SetNotifyAppbar extends StatelessWidget with PreferredSizeWidget {
  const _SetNotifyAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      title: Text(localization!.setNotif),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kAppbarHeight);
}

void _showSnackBar(BuildContext context) {
  final snackBar = SnackBar(
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      content: Text(localization!.errorTitle));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void _getDateAndTimeFromUser(BuildContext context) async {
  Jalali? selectedJalaliDateTime;
  TimeOfDay? startTimeOfDay;
  TimeOfDay? endTimeOfDay;

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
      startTimeOfDay.replacing(hour: startTimeOfDay.hour + 1, minute: 0);

  endTimeOfDay = await showTimePicker(
    context: context,
    initialTime: endTimeOfDayInitialTime,
  );
  if(endTimeOfDay ==null) return;
  context.read<SetReminderBloc>().add(SetReminderDateAndTimeTakenEvent(
      selectedJalaliDateTime: selectedJalaliDateTime,
      startTimeOfDay: startTimeOfDay,
      endTimeOfDay: endTimeOfDay));
}

void _openEnterReminderCountDialog(
    BuildContext context, TextEditingController countController,TextEditingController notificationController) async {
  countController.clear();
  String? reminderCount;
  String? notificationTitle;
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localization!.notificationCountAndTitle),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(justNumberRegex),
                    ],
                    decoration: InputDecoration(
                      hintText: localization!.count,
                      hintStyle: lightTheme.textTheme.subtitle1,
                      filled: true,
                      hoverColor:
                      lightTheme.colorScheme.primary.withOpacity(0.1),
                      enabled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: lightTheme.colorScheme.primary, width: 1)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: notificationController,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: localization!.title,
                    hintStyle: lightTheme.textTheme.subtitle1,
                    filled: true,
                    hoverColor: lightTheme.colorScheme.primary.withOpacity(0.1),
                    enabled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: lightTheme.colorScheme.primary, width: 1)),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (countController.text.isNotEmpty && notificationController.text.isNotEmpty) {
                    Navigator.pop(context);
                    reminderCount = countController.text.trim().toString();
                    notificationTitle = notificationController.text.trim().toString();
                  }
                },
                child: Text(localization!.save))
          ],
        );
      });
  if (reminderCount != null) {
    context
        .read<SetReminderBloc>()
        .add(SetReminderCountAndNotificationTitleTaken(reminderCount: int.parse(reminderCount!),notificationTitle: notificationTitle!));
  }
}
