import 'package:flutter/material.dart';
import 'package:notify_me/src/view/main_screen/main_view.dart';

import '../core/constants/route_constant.dart';
import '../view/set_notify_screen/set_notify_view.dart';

class AppRoutes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var route;

    switch (settings.name) {
      case kMainScreenRoute:
        route = MaterialPageRoute(builder: (_) => MainView());
        break;
      case kSetNotifScreenRoute:
        route = MaterialPageRoute(builder: (_) => SetNotifView());
        break;
    }
    return route;
  }
}
