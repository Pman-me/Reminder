import 'package:flutter/material.dart';

import '../core/constants/route_constant.dart';
import '../view/main_screen/main_screen.dart';
import '../view/set_notify_screen/set_notify_screen.dart';

class AppRoutes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var route;

    switch (settings.name) {
      case kMainScreenRoute:
        route = MaterialPageRoute(builder: (_) => MainScreen());
        break;
      case kSetNotifScreenRoute:
        route = MaterialPageRoute(builder: (_) => SetNotifyScreen());
        break;
    }
    return route;
  }
}
