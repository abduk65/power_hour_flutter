import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/model/meeting_mode.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/edit_text_utils.dart';
import 'package:power_hour_flutter/utils/jitsi_meet_utils.dart';
import 'package:power_hour_flutter/utils/loadingIndicator.dart';
import 'package:provider/provider.dart';
import '../app_content.dart';
import 'host_meeting_card.dart';

class JoinMeeting extends StatefulWidget {
  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  final _joinMeetingFormkey = GlobalKey<FormState>();
  Random _rnd = Random();
  TextEditingController meetingIDController = new TextEditingController();
  TextEditingController nickNameController = new TextEditingController();
  MeetingModel? joinMeetingResponse;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: JitsiMeetUtils().onConferenceWillJoin,
        onConferenceJoined: JitsiMeetUtils().onConferenceJoined,
        onConferenceTerminated: JitsiMeetUtils().onConferenceTerminated,
        onError: JitsiMeetUtils().onError));
  }

  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final AuthService authService = Provider.of<AuthService>(context);
    double screnWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        joinMeetingCard(screnWidth, authService),
        if (isLoading) spinkit,
      ],
    );
  }

  /*Join Meeting Widget*/
  Widget joinMeetingCard(double screnWidth, AuthService authService) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 40, bottom: 50, right: 20),
                child: Form(
                  key: _joinMeetingFormkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppContent.joinAMeeting,
                        style: CustomTheme.displayTextBoldPrimaryColor,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      EditTextUtils().getCustomEditTextField(
                        hintValue: AppContent.meetingID,
                        controller: meetingIDController,
                        prefixWidget: Image.asset(
                          'assets/images/common/hash.png',
                          width: 12,
                          height: 16,
                          scale: 3,
                        ),
                        keyboardType: TextInputType.text,
                        style: CustomTheme.textFieldTitle,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      EditTextUtils().getCustomEditTextField(
                        hintValue: AppContent.yourNickName,
                        controller: nickNameController,
                        prefixWidget: Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: Image.asset(
                            'assets/images/common/person.png',
                            width: 16,
                            scale: 3,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: CustomTheme.textFieldTitle,
                      ),
                      SizedBox(height: 22),
                      GestureDetector(
                          onTap: () async {
                            joinMeetingFunction();
                          },
                          child: submitButton(screnWidth, AppContent.joinNow)),
                    ],
                  ),
                )),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: CustomTheme.boxShadow,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  joinMeetingFunction() async {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    // if (_joinMeetingFormkey.currentState!.validate()) {
      // setState(() {
        // isLoading = true;
      // });
      // String userId =
          // authService.getUser() != null ? authService.getUser()?.userId as String : "0";
      // 0 is default user id when app is free mode
      // joinMeetingResponse = await Repository().joinMeeting(
          // meetingCode: meetingIDController.value.text,
          // userId: userId,
          // nickName: nickNameController.value.text);
      // setState(() {
        // isLoading = false;
      // });
      // if (joinMeetingResponse != null)
        JitsiMeetUtils().joinMeeting(
            roomCode: meetingIDController.value.text,
            nameText: nickNameController.value.text);
    // }
  }
}
