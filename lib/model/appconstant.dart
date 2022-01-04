import 'package:nb_utils/nb_utils.dart';

class AppConstant {
  static final String userid = "userid";
  static final String headertoken = "headertoken";
  static final String isLoggedIn = "isLoggedIn";

  static final int pinkcolor = 0xFFe06287;

  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }
}
