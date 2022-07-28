import 'package:Reminder/src/view/set_reminder_screen/set_notify_screen.dart';
import 'package:flutter/material.dart';

import '../core/constants/route_constant.dart';
import '../view/main_screen/main_screen.dart';

class AppRoutes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var route;

    switch (settings.name) {
      case kMainScreenRoute:
        route = MaterialPageRoute(builder: (_) => MainScreen());
        break;
      case kSetReminderScreenRoute:
        route = MaterialPageRoute(builder: (_) => SetReminderScreen());
        break;
    }
    return route;
  }
}
