import 'package:flutter/material.dart';
import 'package:power_hour_flutter/pages/login_screen.dart';
import 'package:power_hour_flutter/pages/sign_up_screen.dart';

import 'pages/main_screen.dart';


class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      MainScreen.route: (_) => MainScreen(),
      LoginPage.route: (_) => LoginPage(),
      SignUpScreen.route: (_) => SignUpScreen(),
    };
  }
}
