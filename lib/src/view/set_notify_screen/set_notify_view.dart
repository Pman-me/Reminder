import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify_me/gen/assets.gen.dart';
import 'package:notify_me/src/bloc/set_notif_bloc/set_notify_bloc.dart';
import 'package:notify_me/src/configs/app_theme.dart';
import 'package:notify_me/src/core/constants/general_constant.dart';
import 'package:notify_me/src/data/model/notification_scheduler_model.dart';
import 'package:notify_me/src/view/components/nil.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../data/local/object_box_helper.dart';

class SetNotifView extends StatelessWidget {
  SetNotifView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        SetNotifyBloc setNotifyBloc =
        SetNotifyBloc(objectBoxHelper: RepositoryProvider.of<ObjectBoxHelper>(context));
        // if (!setNotifyBloc.isClosed) {
        //   setNotifyBloc.add(SetNotifyStarted());
        // }
        return setNotifyBloc..add(SetNotifyStarted());
      },
      child: BlocBuilder<SetNotifyBloc, SetNotifyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const _SetNotifyAppbar(),
            body: _BodySetNotify(),
            floatingActionButton: _SetNotifyFab(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

class _BodySetNotify extends StatelessWidget {
  const _BodySetNotify({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.read<SetNotifyBloc>().state;
    late Widget result;
    if (state.status == SetNotifyStatus.initial) {
      result = Column(
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
    if (state.status == SetNotifyStatus.success ||
        state.status == SetNotifyStatus.update) {
      if (state.notificationSchedulersList.isNotEmpty) {
        var notificationSchedulerList = state.notificationSchedulersList;
        result = ListView.builder(
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
                      style:
                          lightTheme.textTheme.caption!.copyWith(fontSize: 16),
                    ),
                    trailing: CupertinoSwitch(
                      activeColor: lightTheme.colorScheme.primary,
                      value: notificationScheduler.isActive,
                      onChanged: (value) {
                        context.read<SetNotifyBloc>().add(SetNotifyDisabled(
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
      } else {
        result = SizedBox.expand(
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

    return result;
  }
}

class _SetNotifyFab extends StatelessWidget {
  const _SetNotifyFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.read<SetNotifyBloc>().state;
    late Widget? result;
    if (state.status == SetNotifyStatus.success ||
        state.status == SetNotifyStatus.update) {
      result = Directionality(
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
                .add(SetNotifySelectDateAndTimeClicked(context));
          },
        ),
      );
    } else {
      result = Nil();
    }
    return result;
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

void showSnackBar(BuildContext context) {
  final snackBar = SnackBar(
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      content: Text(localization!.errorTitle));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<String?> openDialogEnterNotificationCount(
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
  return Future.value(result);
}
