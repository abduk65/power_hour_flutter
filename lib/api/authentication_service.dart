import 'package:hive/hive.dart';
import 'package:power_hour_flutter/model/user_model.dart';

class AuthService {
  //Note: persist and update user data
  var box = Hive.box<AuthUser>('user');
  //Note: update user data
  void updateUser(AuthUser user) async {
    print("USER DATA ----- ${user.toJson().toString()}");
    await box.put(0, user);
    print(AuthService().box.getAt(0)!.toJson());
    
    
  }

  //Note: get user data from phone
  AuthUser? getUser() {
    return box.isNotEmpty ? box.get(0) : null;
  }

  //Note: delete user data from phone
  Future<void> deleteUser() {
    return box.delete(0);
  }
}
