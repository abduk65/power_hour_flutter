
// class UpcomingOrder {
//   int id;
//   String bookingId;
//   int salonId;
//   int userId;
//   int empId;
//   String serviceId;
//   Null couponId;
//   int discount;
//   int payment;
//   String date;
//   String startTime;
//   String endTime;
//   String paymentType;
//   String paymentToken;
//   int paymentStatus;
//   String bookingStatus;
//   int commission;
//   int salonIncome;
//   String createdAt;
//   String updatedAt;
//   List<Services> services;
//   UserDetails userDetails;
//   EmpDetails empDetails;
//   Salon salon;
//   bool seeallvisible = true;
//   bool serlistvisible = true;
//   bool newlistvisible = false;

//   UpcomingOrder(
//       {this.id,
//         this.bookingId,
//         this.userId,
//         this.empId,
//         this.date,
//         this.startTime,
//         this.endTime,
//         this.userDetails,
//         this.empDetails,
//         this.salon});

//   UpcomingOrder.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     bookingId = json['booking_id'];
//     salonId = json['salon_id'];
//     userId = json['user_id'];
//     empId = json['emp_id'];
//     serviceId = json['service_id'];
//     couponId = json['coupon_id'];
//     discount = json['discount'];
//     payment = json['payment'];
//     date = json['date'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     paymentType = json['payment_type'];
//     paymentToken = json['payment_token'];
//     paymentStatus = json['payment_status'];
//     bookingStatus = json['booking_status'];
//     commission = json['commission'];
//     salonIncome = json['salon_income'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['services'] != null) {
//       services = new List<Services>();
//       json['services'].forEach((v) {
//         services.add(new Services.fromJson(v));
//       });
//     }
//     userDetails = json['userDetails'] != null
//         ? new UserDetails.fromJson(json['userDetails'])
//         : null;
//     empDetails = json['empDetails'] != null
//         ? new EmpDetails.fromJson(json['empDetails'])
//         : null;
//     salon = json['salon'] != null ? new Salon.fromJson(json['salon']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['booking_id'] = this.bookingId;
//     data['salon_id'] = this.salonId;
//     data['user_id'] = this.userId;
//     data['emp_id'] = this.empId;
//     data['service_id'] = this.serviceId;
//     data['coupon_id'] = this.couponId;
//     data['discount'] = this.discount;
//     data['payment'] = this.payment;
//     data['date'] = this.date;
//     data['start_time'] = this.startTime;
//     data['end_time'] = this.endTime;
//     data['payment_type'] = this.paymentType;
//     data['payment_token'] = this.paymentToken;
//     data['payment_status'] = this.paymentStatus;
//     data['booking_status'] = this.bookingStatus;
//     data['commission'] = this.commission;
//     data['salon_income'] = this.salonIncome;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.services != null) {
//       data['services'] = this.services.map((v) => v.toJson()).toList();
//     }
//     if (this.userDetails != null) {
//       data['userDetails'] = this.userDetails.toJson();
//     }
//     if (this.empDetails != null) {
//       data['empDetails'] = this.empDetails.toJson();
//     }
//     if (this.salon != null) {
//       data['salon'] = this.salon.toJson();
//     }
//     return data;
//   }
// }

