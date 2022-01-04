import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/model/user_model.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/edit_text_utils.dart';
import 'package:power_hour_flutter/utils/loadingIndicator.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import 'dart:io';

import '../app_content.dart';

class EditProfileScreen extends StatefulWidget {
  final AuthUser? authUser;
  final void Function()? profileUpdatedCallback;

  const EditProfileScreen(
      {Key? key,
      @required this.authUser,
      @required this.profileUpdatedCallback})
      : super(key: key);
  @override
  _EditProfileScreenState createState() {
    // TODO: implement createState
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AuthService? _authService;
  final deactivateFormKey = GlobalKey<FormState>();
  TextEditingController? editProfileNameController;
  TextEditingController? editProfileEmailController;
  TextEditingController? editProfilePhoneController;
  TextEditingController deleteController = new TextEditingController();
  TextEditingController accountDeactivateReasonController =
      new TextEditingController();
  String? select;
  bool isLoading = false;
  AuthUser? updatedUser;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editProfileNameController =
        new TextEditingController(text: widget.authUser!.full_name);
    editProfileEmailController =
        new TextEditingController(text: widget.authUser?.email);
    editProfilePhoneController = new TextEditingController(
        text: widget.authUser!.phone != null ? widget.authUser!.phone : '');
    // select = widget.authUser.gender;
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    double screnWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //app title
              _renderAppBar(),
              //_renderProfileWidget
              _renderProfileWidget(screnWidth, _authService!),
              //account deactivate card
            ],
          ),
        ),
      ),
    );
  }

  //renderAppBar
  Widget _renderAppBar() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
      ),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios)),
              SizedBox(
                width: 10,
              ),
              Column(
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
              ),
            ],
          )),
    );
  }

  //renderProfileWidget
  Widget _renderProfileWidget(double screnWidth, AuthService authService) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 25, bottom: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 34.0,
                    ),
                    EditTextUtils().getCustomEditTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: editProfileNameController,
                      prefixWidget: Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: Image.asset(
                          'assets/images/common/person.png',
                          scale: 3,
                        ),
                      ),
                      style: CustomTheme.textFieldTitlePrimaryColored,
                    ),
                    SizedBox(height: 25.0),

                    EditTextUtils().getCustomEditTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: editProfileEmailController,
                        prefixWidget: Image.asset(
                            'assets/images/common/email.png',
                            scale: 3),
                        style: CustomTheme.textFieldTitlePrimaryColored),
                    SizedBox(height: 25.0),
                    EditTextUtils().getCustomEditTextField(
                        keyboardType: TextInputType.number,
                        controller: editProfilePhoneController,
                        prefixWidget: Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: Image.asset(
                            'assets/images/common/edit_phone.png',
                            scale: 3,
                          ),
                        ),
                        style: CustomTheme.textFieldTitlePrimaryColored),
                    SizedBox(
                      height: 25,
                    ),
                    //gender textField

                    SizedBox(height: 14.0),
                    //save changes button
                    GestureDetector(
                        onTap: () async {
                          /*print(widget.authUser.userId);*/
                          setState(() {
                            isLoading = true;
                          });
                          AuthUser user = AuthUser(
                            status: widget.authUser!.status,
                            token: widget.authUser!.token,
                            userId: widget.authUser!.userId,
                            full_name:
                                editProfileNameController!.text.isNotEmpty
                                    ? editProfileNameController!.text
                                    : widget.authUser!.full_name,
                            email: editProfileEmailController!.text.isNotEmpty
                                ? editProfileEmailController!.text
                                : widget.authUser!.email,
                            phone: editProfilePhoneController!.text.isNotEmpty
                                ? editProfilePhoneController!.value.text
                                : widget.authUser!.phone,
                            role: widget.authUser!.role,
                          );

                          updatedUser =
                              await Repository().updateUserProfile(user);
                          setState(() {
                            isLoading = false;
                          });
                          if (updatedUser != null) {
                            authService.updateUser(updatedUser!);
                            widget.profileUpdatedCallback!();
                            if (this.mounted) {
                              setState(() {});
                            }
                          }
                        },
                        child: submitButton(screnWidth, AppContent.saveChanges))
                  ],
                ),
              ),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: CustomTheme.boxShadow,
                color: CustomTheme.white,
              ),
            ),
          ),
          if (isLoading) spinkit,
        ],
      ),
    );
  }
}
