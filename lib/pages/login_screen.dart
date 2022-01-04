import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/bloc/auth/login_bloc.dart';
import 'package:power_hour_flutter/bloc/auth/login_event.dart';
import 'package:power_hour_flutter/bloc/auth/login_state.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'package:power_hour_flutter/pages/sign_up_screen.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/edit_text_utils.dart';
import 'package:power_hour_flutter/utils/loadingIndicator.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';
import 'package:provider/provider.dart';

import '../app_content.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  static final String route = '/LoginScreen';
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final resetPassFormKey = GlobalKey<FormState>();
  // PasswordResetModel passwordResetModel;
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  TextEditingController resetPassEmailController = new TextEditingController();
  bool _isLogged = false;
  Bloc? bloc;
  bool isMandatoryLogin = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<LoginBloc>(context);
    _isLogged = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final authService = Provider.of<AuthService>(context);
    _isLogged = authService.getUser() != null ? true : false;

    return new Scaffold(
      key: _scaffoldKey,
      body: _isLogged ? MainScreen() : _renderLoginWidget(authService),
      // body: _renderLoginWidget(authService),
    );
  }

  Widget _renderLoginWidget(authService) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginCompletingStateCompleted) {
          isLoading = false;
          // AuthUser user = state.getUser;
          AuthUser user = state.getUser;
          if (user == null) {
            /*print('user is null');*/
            bloc!.add(LoginCompletingFailed());
          } else {
            authService.updateUser(user);
          }
          if (authService.getUser() != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false);
          }
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
              child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //app logo bg
                  Container(
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            CustomTheme.primaryColor,
                            CustomTheme.primaryColorDark
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 75.0),
                        child: Image.asset(
                          'assets/images/common/logo.png',
                          width: 74,
                          height: 68,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 60.0),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: CustomTheme.boxShadow,
                                    color: Colors.white,
                                  ),
                                  width: 300.0,
                                  height: 340,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20.0),
                                      Text(
                                        AppContent.login,
                                        style:
                                            CustomTheme.displayTextBoldColoured,
                                      ),
                                      Container(
                                        width: 60,
                                        height: 2,
                                        color: CustomTheme.primaryColor,
                                      ),
                                      SizedBox(height: 15.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: <Widget>[
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                hintValue:
                                                    AppContent.emailAddress,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                controller:
                                                    loginEmailController,
                                                prefixWidget: Image.asset(
                                                  'assets/images/common/email.png',
                                                  scale: 2.5,
                                                ),
                                                style:
                                                    CustomTheme.textFieldTitle,
                                              ),
                                              SizedBox(height: 20),
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                hintValue: AppContent.password,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    loginPasswordController,
                                                prefixWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Image.asset(
                                                      'assets/images/authImage/password.png',
                                                      scale: 2.5),
                                                ),
                                                style:
                                                    CustomTheme.textFieldTitle,
                                                obscureValue: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            AppContent.forgetPassword,
                                            style: CustomTheme.smallTextStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, SignUpScreen.route);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                AppContent.createNewAccount,
                                                style: CustomTheme
                                                    .smallTextStyleColored,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      // if(_formKey.currentState.validate()){
                                      isLoading = true;
                                      bloc!.add(LoginCompletingStarted());
                                      bloc!.add(LoginCompleting(
                                        email: loginEmailController.text,
                                        password: loginPasswordController.text,
                                      ));

                                      // }
                                    },
                                    child: signupSubmitButton(
                                        iconPath: 'login_submit')),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isLoading) spinkit,
            ],
          ));
        },
      ),
    );
  }
}

Widget signupSubmitButton({String? iconPath}) {
  return Container(
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      boxShadow: CustomTheme.iconBoxShadow,
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.asset(
        'assets/images/authImage/${iconPath}.png',
        width: 45,
        height: 45,
      ),
    ),
  );
}
