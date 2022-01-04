import 'package:flutter/material.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/loadingIndicator.dart';
import 'package:power_hour_flutter/utils/toast.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';

// void main() => runApp(SendRequestScreen());

class SendRequestScreen extends StatefulWidget {
  @override
  _SendRequestScreenState createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends State<SendRequestScreen> {
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;

  var disorderCont = TextEditingController();
  var requestCont = TextEditingController();
  var disorderFocus = FocusNode();
  var requestFocus = FocusNode();
  var mIsLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> saveData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      mIsLoading = true;
      setState(() {});
      await Repository()
          .createRequest(disorderCont.text, requestCont.text)
          .then((value) {
        if (value.data['status'] == true) {
          setState(() {});
          toastMessage("Request has been created Successfully ");
        }
      }).catchError((e) {
        toastMessage(e.toString());
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    disorderFocus.dispose();
    requestFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  TextFormField(
                    controller: disorderCont,
                    focusNode: disorderFocus,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.medical_services_rounded,
                          color: CustomTheme.lightColor),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: CustomTheme.overlayDark)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1, color: CustomTheme.overlayDark)),
                      labelText: 'Disorder',
                      labelStyle: primaryTextStyle(),
                    ),
                    cursorColor: CustomTheme.lightColor,
                    keyboardType: TextInputType.name,
                    validator: (s) {
                      if (s!.trim().isEmpty) return 'Disorder is required';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: requestCont,
                    focusNode: requestFocus,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.subject_rounded,
                          color: CustomTheme.lightColor),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: CustomTheme.overlayDark)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1, color: CustomTheme.overlayDark)),
                      labelText: 'Request Statement',
                      labelStyle: primaryTextStyle(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    cursorColor: CustomTheme.primaryColorDark,
                    keyboardType: TextInputType.multiline,
                    validator: (s) {
                      if (s!.trim().isEmpty) return 'Address is required';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await saveData();

                      disorderCont.clear();
                      requestCont.clear();

                      mIsLoading = false;
                      setState(() {});
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.white)),
                    child: Text(
                      'Request Therapy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    child: spinkit,
                    visible: mIsLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  primaryTextStyle() {
    return TextStyle(
      color: CustomTheme.grey,
    );
  }
}
