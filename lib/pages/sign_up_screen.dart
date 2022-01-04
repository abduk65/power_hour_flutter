import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/bloc/auth/registration_bloc.dart';
import 'package:power_hour_flutter/bloc/auth/registration_event.dart';
import 'package:power_hour_flutter/bloc/auth/registration_state.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'package:power_hour_flutter/pages/main_screen.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/edit_text_utils.dart';
import 'package:power_hour_flutter/utils/loadingIndicator.dart';
import 'package:provider/provider.dart';
import '../app_content.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static final String route = '/SignUpScreen';
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() {
    // TODO: implement createState
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _signUpFormkey = GlobalKey<FormState>();
  TextEditingController loginNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool? _isRegistered = false;
  Bloc? bloc;
  bool isMandatoryLogin = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<RegistrationBloc>(context);
    _isRegistered = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final authService = Provider.of<AuthService>(context);

    ///read user data from phone(flutter hive box)
    _isRegistered = authService.getUser() != null ? true : false;
    return new Scaffold(
      key: _scaffoldKey,
      body: _renderRegisterWidget(authService),
    );
  }

  Widget _renderRegisterWidget(authService) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationStateCompleted) {
          isLoading = false;
          AuthUser user = state.getUser;
          if (user is! AuthUser) {
            print("user is null");
            bloc!.add(RegistrationFailed());
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
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return SingleChildScrollView(
              child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            CustomTheme.primaryColor,
                            CustomTheme.primaryColorDark
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 75.0),
                        child: Image.asset(
                          'assets/images/common/logo.png',
                          scale: 5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 23.0),
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
                                  height: 400,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20.0),
                                      Text(
                                        AppContent.signup,
                                        style:
                                            CustomTheme.displayTextBoldColoured,
                                      ),
                                      Container(
                                          width: 60,
                                          height: 2,
                                          color: CustomTheme.primaryColor),
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                        ),
                                        child: Form(
                                          key: _signUpFormkey,
                                          child: Column(
                                            children: <Widget>[
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                hintValue: AppContent.name,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: loginNameController,
                                                prefixWidget: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 9),
                                                  child: Image.asset(
                                                    'assets/images/common/person.png',
                                                    scale: 3.5,
                                                  ),
                                                ),
                                                style:
                                                    CustomTheme.textFieldTitle,
                                              ),
                                              SizedBox(height: 10),
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
                                                  scale: 3.5,
                                                ),
                                                style:
                                                    CustomTheme.textFieldTitle,
                                              ),
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                hintValue: "0901031331",
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: phoneController,
                                                prefixWidget: Container(
                                                  child: Icon(Icons.phone),
                                                ),
                                                style:
                                                    CustomTheme.textFieldTitle,
                                              ),
                                              SizedBox(height: 10),
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
                                                          left: 9),
                                                  child: Image.asset(
                                                    'assets/images/authImage/password.png',
                                                    scale: 3.5,
                                                  ),
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
                                            AppContent.alReadyHaveAccount,
                                            style: CustomTheme.smallTextStyle,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, LoginPage.route);
                                              },
                                              child: Text(
                                                AppContent.logInHere,
                                                style: CustomTheme
                                                    .smallTextStyleColoredUnderLine,
                                              )),
                                        ],
                                      ),
                                      Text(
                                        AppContent.byPressingSubmit,
                                        style: CustomTheme.smallTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    isLoading = true;
                                    AuthUser user = AuthUser(
                                        full_name: loginNameController.text,
                                        phone: phoneController.text,
                                        email: loginEmailController.text);
                                    // Registration started bloc
                                    bloc!.add(RegistrationStarted());
                                    bloc!.add(RegistrationCompleting(
                                        user: user,
                                        password:
                                            loginPasswordController.text));
                                  },
                                  child: signupSubmitButton(
                                      iconPath: 'login_submit'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            SizedBox(height: 50.0),
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

//   ValueListenableBuilder(
//     valueListenable:
//         Hive.box<GetConfigModel>(
//                 'getConfigbox')
//             .listenable(),
//     builder: (context,
//         Box<GetConfigModel> box, widget) {
//       isMandatoryLogin = box
//           .get(0)
//           ?.appConfig
//           .mandatoryLogin;
//       return !isMandatoryLogin
//           ? GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: Padding(
//                 padding:
//                     const EdgeInsets.all(
//                         8.0),
//                 child: Text(
//                   AppContent.backText,
//                   style: CustomTheme
//                       .smallTextStyleColored,
//                 ),
//               ),
//             )
//           : Container();
//     },
//   ),
