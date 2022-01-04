import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:power_hour_flutter/config.dart';
import 'package:power_hour_flutter/model/appconstant.dart';
import 'package:power_hour_flutter/model/booking_response.dart';
import 'package:power_hour_flutter/model/emp_response.dart';
import 'package:power_hour_flutter/model/meeting_mode.dart';
import 'package:power_hour_flutter/model/time_data.dart';
import 'package:power_hour_flutter/model/user_model.dart';

import 'authentication_service.dart';

class Repository {
  static final String baseUrl = Config.baseUrl;
  static final String apiKey = Config.apiKey;
  static final String token = "";
  AuthUser? authUser = AuthService().box.get(0);

  Dio dio = Dio();
  Future<AuthUser?> getLoginAuthUser(String email, String password) async {
    // dio.options.headers = {"API-KEY": apiKey};
    FormData formData = new FormData.fromMap({
      "email": email,
      "password": password,
    });
    try {
      final response = await dio.post(
        "${baseUrl}/api/login",
        data: formData,
      );
      AuthUser user = AuthUser.fromJson(response.data);
      if (user is AuthUser) {
        return user;
      } else {
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //User Registration
  Future<AuthUser?> getRegistrationAuthUser(
      String email, String password, String full_name, String phone) async {
    // dio.options.headers = {"API-KEY": Config.apiKey};
    FormData formData = new FormData.fromMap({
      // "name": name,
      "email": email,
      "password": password,
      "password_confirmation": password,
      "role": 3,
      "full_name": full_name,
      "phone": phone
    });
    try {
      final response =
          await dio.post("${baseUrl}/api/register", data: formData);
      AuthUser user = AuthUser.fromJson(response.data);
      print("registeration usre ${response.data.toString()}");
      if (user.email is String) {
        return user;
      } else {
        showShortToast(response.toString());
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //update user info
  Future<AuthUser?> updateUserProfile(AuthUser user) async {
    // dio.options.headers = {"API-KEY": apiKey};
    FormData formData = new FormData.fromMap({
      "full_name": user.full_name,
      "email": user.email,
      "phone": user.phone,
      "id": user.userId,
      "token": authUser!.token
    });

    try {
      final response = await dio.post(
        "${baseUrl}/api/update",
        data: formData,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      print(response.toString());
      AuthUser updateAuthUser = AuthUser.fromJson(response.data);
      // if (updateAuthUser.status == 'success') {
      // showShortToast(updateAuthUser.status);
      if (response.data["token"] == authUser!.token) {
        print("updatedUser info is ${updateAuthUser.toString()}");
        return updateAuthUser;
      } else {
        showShortToast(response.toString());
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<MeetingModel?> joinMeeting(
      {String? meetingCode, String? userId, String? nickName}) async {
    dio.options.headers = {"API-KEY": apiKey};
    FormData formData = new FormData.fromMap({
      "meeting_code": meetingCode,
      "user_id": userId,
      "nick_name": nickName
    });
    try {
      final response =
          await dio.post("${baseUrl}/api/v100/join_meetting/", data: formData);
      MeetingModel joinResponse = MeetingModel.fromJson(response.data);
      if (joinResponse.status == 'success') {
        return joinResponse;
      } else {
        showShortToast(response.data['message']);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<MeetingModel?> hostMeeting(
      {String? meetingCode, String? userId, String? meetingTitle}) async {
    dio.options.headers = {"API-KEY": apiKey};
    FormData formData = new FormData.fromMap({
      "meeting_code": meetingCode,
      "user_id": userId,
      "meeting_title": meetingTitle,
    });
    try {
      final response = await dio.post(
          "${baseUrl}/api/v100/create_and_join_meetting/",
          data: formData);
      MeetingModel joinResponse = MeetingModel.fromJson(response.data);
      if (joinResponse.status == 'success') {
        return joinResponse;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<TimeDataResponseModel?> timeslot(String date) async {
    ArgumentError.checkNotNull(date, 'date');
    FormData formData = new FormData.fromMap({
      "salon_id": 1,
      "date": date,
    });
    try {
      Response<dynamic> response =
          await dio.post("${baseUrl}/api/timeslot", data: formData);
      // TODO - edit this
      TimeDataResponseModel timeSlot =
          TimeDataResponseModel.fromJson(response.data);
      if (response.data != null) {
        return timeSlot;
      } else {
        showShortToast(response.toString());
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<EmpResponse?> selectemp(String? time, String date) async {
    ArgumentError.checkNotNull(time, 'start_time');
    ArgumentError.checkNotNull(date, 'date');
    FormData formData = new FormData.fromMap({
      "start_time": time,
      "date": date,
    });
    // TODO- check url endpoint
    try {
      final response =
          await dio.post("${baseUrl}/api/selectemp", data: formData);
      // TODO - edit this
      EmpResponse empList = EmpResponse.fromJson(response.data);

      if (response.data != null) {
        return empList;
      } else {
        showShortToast(response.toString());
        print(response.data);
        return null;
      }
    } catch (e) {
      print("exceptionoccured----------------");
      print(e);
      return null;
    }
  }

  Future<BookingResponse?> booking(emp_id, date, start_time) async {
    ArgumentError.checkNotNull(emp_id, 'emp_id');
    ArgumentError.checkNotNull(date, 'date');
    ArgumentError.checkNotNull(start_time, 'start_time');
    // print("id is $id");
    print("usr is currently with token ${authUser!.token}");
    FormData formData = new FormData.fromMap({
      "emp_id": emp_id,
      "date": date,
      "start_time": start_time,
      "id": authUser!.userId
    });
    try {
      print(AppConstant.headertoken);
      final response = await dio.post(
        "${baseUrl}/api/booking",
        data: formData,
        options: Options(
            // TODO- Remember to remove this
            // headers: {"Authorization": "Bearer ${AppConstant.headertoken}"},
            ),
      );
      // TODO - edit this
      BookingResponse bookingResponse = BookingResponse.fromJson(response.data);
      if (response.data != null) {
        return bookingResponse;
      } else {
        showShortToast(response.toString());
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> createRequest(disorder, request_statement) async {
    ArgumentError.checkNotNull(disorder, 'disorder');
    ArgumentError.checkNotNull(request_statement, 'request_statement');
    // print("id is $id");
    print("usr is currently with token ${authUser!.token}");
    FormData formData = new FormData.fromMap({
      "disorder": disorder,
      "request_statement": request_statement,
      "patient_id": authUser!.userId ?? 7
    });
    try {
      print(AppConstant.headertoken);
      final response = await dio.post(
        "${baseUrl}/api/newrequest",
        data: formData,
        options: Options(
            // TODO- Remember to remove this
            // headers: {"Authorization": "Bearer ${AppConstant.headertoken}"},
            ),
      );
      // TODO - edit this
      if (response.data != null) {
        print(
            "The following is the reposne from the request ${response.toString()}");
        return response;
      } else {
        showShortToast(response.toString());
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

void showShortToast(String message) {
  Fluttertoast.showToast(
      msg: message, toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1);
}
