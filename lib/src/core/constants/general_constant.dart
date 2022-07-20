import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations? localization;

const String kHiveBoxName = 'notifyTimeBox';

RegExp justNumberRegex = RegExp(r"[0-9]+");

const double kAppbarHeight = 56;
const int kMinimumInterval = 5; // minute

const String kNotificationChannelId = 'notifyId';
const String kNotificationChannelName = 'Notify me';
const int kNotificationId = 10001;
const int k24HourIntervalInMilliseconds = 86400;
