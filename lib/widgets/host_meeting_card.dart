import 'dart:math';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/model/meeting_mode.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/edit_text_utils.dart';
import 'package:power_hour_flutter/utils/jitsi_meet_utils.dart';
import 'package:power_hour_flutter/utils/loadingIndicator.dart';
import '../app_content.dart';
// import 'package:share/share.dart';

import 'package:provider/provider.dart';

import '../config.dart';

class HostMeetingCard extends StatefulWidget {
  @override
  _HostMettingCardState createState() => _HostMettingCardState();
}

class _HostMettingCardState extends State<HostMeetingCard> {
  TextEditingController meetingTitleController = new TextEditingController();
  MeetingModel? hostMeetingResponse;
  // PackageInfo _packageInfo = PackageInfo(
  //     appName: 'AppName', buildNumber: '', packageName: '', version: '');
  var _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'; //all characters
  Random _rnd = Random();
  String? randomMeetingCode; //meeting room
  bool isLoading = false;
  String? joinWebUrl;
  String? meetingPrefix;
  String? linkMessage;

  var baseUrl = Config.baseUrl;

  @override
  void initState() {
    // TODO: implement initState
    // _initPackageInfo();
    meetingPrefix = "MT";
    randomMeetingCode = meetingPrefix! + getRandomString(9);
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: JitsiMeetUtils().onConferenceWillJoin,
        onConferenceJoined: JitsiMeetUtils().onConferenceJoined,
        onConferenceTerminated: JitsiMeetUtils().onConferenceTerminated,
        onError: JitsiMeetUtils().onError));

    super.initState();
  }

  //Regerating Random Meeting Code
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    joinWebUrl = "${baseUrl}/room/$randomMeetingCode";
    double screnWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        joinMeetingCard(screnWidth, authService),
        if (isLoading) spinkit,
      ],
    );
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppContent.createAMeeting,
                    style: CustomTheme.displayTextBoldPrimaryColor,
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    height: 48.0,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      border: Border.all(color: CustomTheme.lightColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset('assets/images/common/hash.png',
                                  scale: 3.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  randomMeetingCode!,
                                  style: CustomTheme.textFieldTitle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  /* user meeting title textField */
                  EditTextUtils().getCustomEditTextField(
                    hintValue: AppContent.meetingTitleOptional,
                    controller: meetingTitleController,
                    prefixWidget: Image.asset(
                      'assets/images/common/person.png',
                      scale: 3,
                    ),
                    keyboardType: TextInputType.text,
                    style: CustomTheme.textFieldTitle,
                  ),
                  SizedBox(height: 15.0),
                  // sendInvitation(
                  //     title: AppContent.sendInvitation,
                  //     meetingCode: randomMeetingCode,
                  //     appName: _packageInfo.appName,
                  //     joinWebUrl: joinWebUrl),
                  SizedBox(height: 15.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //         width: screnWidth * 0.30,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Card(
                  //               color: Colors.white54,
                  //               child: SizedBox(
                  //                 width: screnWidth * 0.60 * 0.70,
                  //               height: screnWidth * 0.40 * 0.70,
                  //                 child: JitsiMeetConferencing(
                  //                   extraJS: [
                  //                     // extraJs setup example
                  //                     '<script>function echo(){console.log("echo!!!")};</script>',
                  //                     '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                  //                   ],
                  //                 ),
                  //               )),
                  //         ))
                  //   ],
                  // ),
                  GestureDetector(
                      onTap: () async {
                        // If interstitialAd has not loaded due to any reason simply load hostMeeting Function
                        hostMeetingFunction();
                      },
                      child: submitButton(screnWidth, AppContent.createJoinNow))
                ],
              ),
            ),
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

  hostMeetingFunction() async {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    String meetingTitle = meetingTitleController.value.text;
    String userId =
        authService.getUser() != null ? authService.getUser()?.userId : "0";
    //0 is default user id when app is free mode
    hostMeetingResponse = await Repository().hostMeeting(
        meetingCode: randomMeetingCode,
        userId: userId,
        meetingTitle: meetingTitle);
    /*print(hostMeetingResponse);*/
    setState(() {
      isLoading = false;
    });
    if (hostMeetingResponse != null)
      JitsiMeetUtils()
          .hostMeeting(roomCode: randomMeetingCode, meetingTitle: meetingTitle);
  }
}

Widget submitButton(double width, String title, {double height = 40}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: [CustomTheme.primaryColor, CustomTheme.primaryColorDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    child: Center(
        child: Text(
      title,
      style: CustomTheme.btnTitle,
    )),
  );
}

// Widget sendInvitation(
//     {String? title, String? meetingCode, String? appName, String? joinWebUrl}) {
//   return GestureDetector(
//     onTap: () {
//       String shareText = "${AppContent.joinMeetingWith}" +
//           appName! +
//           "\n" +
//           "${AppContent.joinFromWeb}" +
//           joinWebUrl! +
//           "\n" +
//           "${AppContent.joinFromApp} $meetingCode";
//       Share.share(shareText);
//     },
//     child: Container(
//       height: 45.0,
//       decoration: new BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(3.0)),
//         border: Border.all(color: CustomTheme.primaryColor),
//       ),
//       child: Center(
//           child: Text(
//         title!,
//         style: CustomTheme.subTitleTextColored,
//       )),
//     ),
//   );
// }
