import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:power_hour_flutter/pages/schedule_screen.dart';
import 'package:power_hour_flutter/route.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api/authentication_service.dart';
import 'api/repository.dart';
import 'bloc/auth/login_bloc.dart';
import 'bloc/auth/registration_bloc.dart';
import 'pages/login_screen.dart';
import 'pages/main_screen.dart';
import 'pages/onboard_screen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin {
  // GetConfigModel getConfigModel;
  bool isFirstSeen = true;
  String notifyContent = '';

  @override
  void initState() {
    super.initState();
    // configOneSignal();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    isFirstSeen = await checkFirstSeen();
    setState(() {});
  }

  Future checkFirstSeen() async {
    var box = Hive.box('seenBox');
    bool _seen = await box.get("isFirstSeen") ?? false;
    if (_seen) {
      return false;
    } else {
      await box.put("isFirstSeen", true);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        // Provider<GetConfigService>(create: (context) => GetConfigService(),),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc(Repository())),
          BlocProvider(create: (context) => RegistrationBloc(Repository())),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: Routes.getRoute(),
            // home: RenderFirstScreen(
            //   isFirstSeen: isFirstSeen,
            // ),
            home: RenderFirstScreen()),
      ),
    );
  }
  // void configOneSignal() async {
  //   await OneSignal.shared.init(Config.oneSignalAppID);
  //   //show notification content
  //   OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  //   OneSignal.shared.setNotificationReceivedHandler((notification) {
  //     //content notification
  //     setState(() {
  //       notifyContent = notification.jsonRepresentation().replaceAll('\\n', '\n');
  //     });

  //   });
  // }
}

class RenderFirstScreen extends StatelessWidget {
  RenderFirstScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return renderFirstScreen();
  }

  Widget renderFirstScreen() {
    return OnBoardScreen();
  }
}
