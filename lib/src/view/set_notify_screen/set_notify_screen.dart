import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../gen/assets.gen.dart';
import '../../bloc/set_notif_bloc/set_notify_bloc.dart';
import '../../configs/app_theme.dart';
import '../../core/constants/general_constant.dart';
import '../../data/local/object_box_helper.dart';
import '../../data/model/notification_scheduler_model.dart';
import '../components/nil.dart';

class SetNotifyScreen extends StatelessWidget {
  SetNotifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetNotifyBloc(
          objectBoxHelper: RepositoryProvider.of<ObjectBoxHelper>(context))
        ..add(SetNotifyStarted()),
      child: BlocBuilder<SetNotifyBloc, SetNotifyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const _SetNotifyAppbar(),
            body: _SetNotifyBody(),
            floatingActionButton:  (state is SetNotifyInitial)? Nil(): const _SetNotifyFab(),
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
    return BlocConsumer<SetNotifyBloc, SetNotifyState>(
        buildWhen: (previous, current) {
      if (current is SetNotifyShowEnterNotificationCountDialog ||
          current is SetNotifyShowDateAndTimePicker ||
          current is SetNotifyShowSnackBar) {
        return false;
      } else {
        return true;
      }
    }, builder: (context, state) {
      late Widget result;
      if (state is SetNotifyInitial) {
        result = _initialView();
      }
      if (state is SetNotifySuccess || state is SetNotifyUpdate) {
        if (state.notificationSchedulersList.isNotEmpty) {
          var notificationSchedulerList = state.notificationSchedulersList;
          result = _successView(notificationSchedulerList);
        } else {
          result = _emptyView();
        }
      }

      return result;
    }, listener: (context, state) {
      if (state is SetNotifyShowSnackBar) {
        _showSnackBar(context);
      }
      if (state is SetNotifyShowDateAndTimePicker) {
        _getDateAndTimeFromUser(context);
      }
      if(state is SetNotifyShowEnterNotificationCountDialog){
        _openEnterReminderCountDialog(context,state.textEditingController);
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
                    context.read<SetNotifyBloc>().add(
                        SetNotifyReminerDisabledEvent(
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
              .read<SetNotifyBloc>()
              .add(SetNotifySelectDateAndTimeClicked());
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
  context.read<SetNotifyBloc>().add(SetNotifyDateAndTimeTakenEvent(
      selectedJalaliDateTime: selectedJalaliDateTime,
      startTimeOfDay: startTimeOfDay,
      endTimeOfDay: endTimeOfDay));
}

void _openEnterReminderCountDialog(
    BuildContext context, TextEditingController controller) async {
  controller.clear();
  String? result;
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localization!.notificationCount),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(justNumberRegex),
            ],
            decoration: InputDecoration(
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
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    Navigator.pop(context);
                    result = controller.text.trim().toString();
                  }
                },
                child: Text(localization!.save))
          ],
        );
      });
  if(result !=null){
    context.read<SetNotifyBloc>().add(SetNotifyReminderCountTaken(reminderCount: int.parse(result!)));
  }
}
