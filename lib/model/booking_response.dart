class BookingResponse {
  String? msg;
  BookingData? data;
  bool? success;

  BookingResponse({this.msg, this.data, this.success});

  BookingResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new BookingData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class BookingData {
  String? endTime;
  String? salonId;
  String? empId;
  String? payment;
  String? startTime;
  String? date;
  int? userId;
  String? bookingId;
  String? bookingStatus;
  String? updatedAt;
  String? createdAt;
  int? id;
  UserDetails? userDetails;

  BookingData(
      {this.endTime,
      this.salonId,
      this.empId,
      this.startTime,
      this.date,
      this.userId,
      this.bookingId,
      this.bookingStatus,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.userDetails});

  BookingData.fromJson(Map<String, dynamic> json) {
    endTime = json['end_time'];
    salonId = json['salon_id'];
    empId = json['emp_id'];
    payment = json['payment'];
    startTime = json['start_time'];
    date = json['date'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    bookingStatus = json['booking_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];

    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_time'] = this.endTime;
    data['salon_id'] = this.salonId;
    data['emp_id'] = this.empId;
    data['payment'] = this.payment;
    data['start_time'] = this.startTime;
    data['date'] = this.date;
    data['user_id'] = this.userId;
    data['booking_id'] = this.bookingId;
    data['booking_status'] = this.bookingStatus;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;

    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? status;
  int? role;
  String? createdAt;
  String? updatedAt;
  String? salonName;

  UserDetails(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.status,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.salonName});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    status = json['status'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salonName = json['salonName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['salonName'] = this.salonName;
    return data;
  }
}
