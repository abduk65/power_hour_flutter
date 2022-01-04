import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'package:power_hour_flutter/pages/login_screen.dart';
import 'package:power_hour_flutter/pages/onboard_screen.dart';
import 'package:power_hour_flutter/pages/schedule_screen.dart';
import 'package:power_hour_flutter/pages/send_request.dart';
import 'package:power_hour_flutter/pages/sign_up_screen.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:provider/provider.dart';
import '../app_content.dart';
import 'meeting_screen.dart';
import 'appointment.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  static final String route = '/MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AuthService? authService;
  AuthUser? authUser;
  // GetConfigService configService;
  bool? _keyboardState = false;
  String appMode = 'free';
  bool ismandatoryLogin = true;
  TabController? _controller;

  @override
  void initState() {
    _controller = new TabController(vsync: this, length: 3, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    authUser = authService!.getUser() != null ? authService!.getUser() : null;

    return Scaffold(
        body: TabBarView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SettingScreen(),
            SendRequestScreen(),
            MeetingScreen(),
            // Appointment()            
          ],
        ),
        bottomNavigationBar: _keyboardState!
            ? Container(
                height: 0.0,
                width: 0.0,
              )
            : Container(
                decoration: BoxDecoration(
                  boxShadow: CustomTheme.navBoxShadow,
                ),
                child: Material(
                  child: StyleProvider(
                    style: NavStyle(),
                    child: ConvexAppBar(
                      elevation: 0.0,
                      height: 60,
                      top: -42,
                      activeColor: Colors.transparent,
                      color: Colors.transparent,
                      curveSize: 0.0,
                      style: TabStyle.fixedCircle,
                      items: [
                        bottomNavigationTabIcon(
                            icon: 'assets/images/tabs/setting_inactive.png',
                            activeIcon: 'assets/images/tabs/setting_active.png',
                            title: AppContent.tabsSettings),
                        bottomNavigationTabIcon(
                          icon: 'assets/images/tabs/history_inactive.png',
                          activeIcon: 'assets/images/tabs/history_active.png',
                          title: AppContent.tabsHistory,
                        ),
                        TabItem(
                          isIconBlend: false,
                          activeIcon: Image.asset(
                              'assets/images/tabs/meeting_active.png'),
                          icon: Image.asset(
                              'assets/images/tabs/meeting_inactive.png'),
                          title: AppContent.tabsMeetingEmptyText, //no title
                        ),
                        
                      ],
                      backgroundColor: CustomTheme.bottomNavBGColor,
                      controller: _controller,
                    ),
                  ),
                ),
              ));
  }
}

TabItem<dynamic> bottomNavigationTabIcon(
    {String? icon, activeIcon, String? title}) {
  return TabItem(
    isIconBlend: false,
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Image.asset(icon!),
    ),
    activeIcon: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Image.asset(activeIcon),
    ),
    title: title,
  );
}


class NavStyle extends StyleHook {
  @override
  double get activeIconSize => 35;

  @override
  double get activeIconMargin => 8;

  @override
  double get iconSize => 30;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(
        fontSize: 10, color: CustomTheme.bottomNavTextColor, fontFamily: 'Avenir');
  }
}



