import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';
import 'package:power_hour_flutter/widgets/join_meeting_card.dart';
import 'package:provider/provider.dart';

import '../app_content.dart';

class MeetingScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  MeetingScreen({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  int selectedScreen = 0;
  AuthUser? _authUser;
  String userRole = '';
  bool ismandatoryLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    _authUser = authService.getUser() != null ? authService.getUser() : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[meetingLinkWidget()],
        ),
      ),
    );
  }

  Widget meetingLinkWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 28),
            child: Text(
              "join meeting by entering code received",
              style: CustomTheme.screenTitle,
            ),
          ),
          /*Join meeting and Host Meeting Switch Button*/
          SizedBox(height: 10.0),
          Container(
            height: 500.0,
            child: JoinMeeting(),
          ),
        ],
      ),
    );
  }
}
