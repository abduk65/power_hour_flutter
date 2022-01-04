import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/app.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'package:power_hour_flutter/pages/main_screen.dart';
import 'package:power_hour_flutter/pages/send_request.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/toast.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';
import 'package:provider/provider.dart';

import '../app_content.dart';
import 'edit_profile.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AuthService? authService;
  AuthUser? authUser =
      AuthService().getUser() != null ? AuthService().getUser() : null;
  String output = "";

  ///authUserUpdated will be called from edit profile screen if user update user info.
  void authUserUpdated() {
    toastMessage("Profile Updated Successfully");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false);
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _renderAppBar(),
                if (authUser != null)
                  userInfoCard(authUser!, context, authUserUpdated),
                if (authUser != null) logoutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 28.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppContent.titleSettingsScreen,
                style: CustomTheme.screenTitle,
              ),
              Text(
                AppContent.subTitleSettingsScreen,
                style: CustomTheme.displayTextOne,
              )
            ],
          )),
    );
  }

  Widget logoutSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(AppContent.areYouSureLogout),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15)),
                  actionsPadding: EdgeInsets.only(right: 15.0),
                  actions: <Widget>[
                    GestureDetector(
                        onTap: () async {
                          if (authService!.getUser() != null)
                            authService!.deleteUser();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MyApp()),
                              (Route<dynamic> route) => false);
                        },
                        child:
                            submitButton(60, AppContent.yesText, height: 30.0)),
                    SizedBox(
                      width: 8.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:
                            submitButton(60, AppContent.noText, height: 30.0)),
                  ],
                );
              });
        },
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                title: Text(
                  AppContent.logout,
                  style: CustomTheme.alartTextStyle,
                ),
              ),
            ],
          ),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: CustomTheme.boxShadow,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget userInfoCard(AuthUser authUser, context, authUserUpdated) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            authUser: authUser,
            profileUpdatedCallback: authUserUpdated,
          ),
          // builder: (context) => Container(
          //   child: Text("EditScreen"),
          // ),
        ),
      );
    },
    child: Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      authUser.email,
                      style: CustomTheme.displayTextBoldColoured,
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              'assets/images/common/arrow_forward.png',
              scale: 2.5,
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: CustomTheme.boxShadow,
        color: Colors.white,
      ),
    ),
  );
}
