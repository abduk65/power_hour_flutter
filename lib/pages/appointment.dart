// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:intl/intl.dart';
// import 'package:dio/dio.dart';
// import 'package:power_hour_flutter/api/repository.dart';
// import 'package:power_hour_flutter/utils/toast.dart';

// import 'schedule_screen.dart';

// class Appoinment extends StatefulWidget {
//   @override
//   _Appoinment createState() => new _Appoinment();
// }

// class _Appoinment extends State<Appoinment>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _drawerscaffoldkey =
//       new GlobalKey<ScaffoldState>();

//   List<UpcomingOrder> upcomingorderdataList = List.empty(growable: true);
//   bool noupdatavisible = true;
//   bool uplistvisible = false;

//   bool nocanceldatavisible = true;
//   bool cancellistvisible = false;

//   bool nocompletedatavisible = true;
//   bool completelistvisible = false;

//   bool isShowReview = false;

//   List<String> upcomingServiceList = List.empty(growable: true);

//   TextEditingController reviewTextController = new TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   String name = "User";

//   @override
//   void initState() {
//     super.initState();
//     if (mounted) {
//       setState(() {
//         CallApiforAppointment();
//       });
//     }
//   }

//   // ignore: non_constant_identifier_names
//   void CallApiforAppointment() {
//     Repository().appointment().then((response) {
//       if (mounted) {
//         setState(() {
//           if (response.success = true) {
//             upcomingorderdataList.clear();
//             if (response.data.upcomingOrder.length > 0) {
//               upcomingorderdataList.addAll(response.data.upcomingOrder);
//               // servicelist.addAll(upcomingorderdataList[currentindex].services);
//               uplistvisible = true;
//               noupdatavisible = false;
//             } else {
//               uplistvisible = false;
//               noupdatavisible = true;
//             }
//           }
//         });
//       }
//     }).catchError((Object obj) {
//       print(obj.runtimeType);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     dynamic screenHeight = MediaQuery.of(context).size.height;
//     dynamic screenwidth = MediaQuery.of(context).size.width;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         key: _drawerscaffoldkey,
//         body: new Stack(
//           children: <Widget>[
//             new SingleChildScrollView(
//               physics: NeverScrollableScrollPhysics(),
//               child: Container(
//                 margin: EdgeInsets.only(top: 5.0, left: 10, right: 10),
//                 color: Colors.white,
//                 child: ListView(
//                   shrinkWrap: true,
//                   physics: AlwaysScrollableScrollPhysics(),
//                   children: <Widget>[
//                     Visibility(
//                       visible: uplistvisible,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: upcomingorderdataList.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           var parsedDate;
//                           parsedDate =
//                               DateTime.parse(upcomingorderdataList[index].date);
//                           var df = new DateFormat('MMM dd,yyyy');
//                           parsedDate = df.format(parsedDate);

//                           upcomingServiceList.clear();
//                           for (int i = 0;
//                               i < upcomingorderdataList[index].services.length;
//                               i++) {
//                             upcomingServiceList.add(
//                                 upcomingorderdataList[index].services[i].name);
//                           }

//                           return Container(
//                             margin:
//                                 EdgeInsets.only(left: 10, right: 10, top: 10),
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: const Color(0xFFf1f1f1), width: 3),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 0.0),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         // height: 100.0,
//                                         width: screenwidth * .65,
//                                         height: 110,
//                                         margin: EdgeInsets.only(
//                                             left: 5.0, top: 0.0),
//                                         alignment: Alignment.topLeft,
//                                         color: Colors.white,
//                                         child: ListView(
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           children: <Widget>[
//                                             Row(
//                                               children: <Widget>[
//                                                 Container(
//                                                   alignment: Alignment.center,
//                                                   width: 5.0,
//                                                   height: 5.0,
//                                                   margin: EdgeInsets.only(
//                                                       left: 5.0, top: 5.0),
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: Color(0xFF9e9e9e),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                       left: 5.0,
//                                                       top: 5.0,
//                                                       right: 0),
//                                                   child: RichText(
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     textScaleFactor: 1,
//                                                     textAlign: TextAlign.center,
//                                                     text: TextSpan(
//                                                       children: [
//                                                         WidgetSpan(
//                                                           child: Icon(
//                                                             Icons
//                                                                 .calendar_today,
//                                                             size: 14,
//                                                             color: Colors
//                                                                 .purpleAccent[50],
//                                                           ),
//                                                         ),
//                                                         TextSpan(
//                                                           text: upcomingorderdataList[
//                                                                       index]
//                                                                   .startTime +
//                                                               " - " +
//                                                               parsedDate,
//                                                           style: TextStyle(
//                                                               color: Color(
//                                                                   0xFF9e9e9e),
//                                                               fontSize: 11,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontFamily:
//                                                                   'Montserrat'),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 MySeparator(color: Color(0xFF9e9e9e)),
//                                 Padding(
//                                   padding: const EdgeInsets.all(0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Container(
//                                         width: screenwidth * .33,
//                                         margin: EdgeInsets.only(
//                                             left: 5.0, right: 10.0),
//                                         color: Colors.white,
//                                         alignment: Alignment.topLeft,
//                                         child: ListView(
//                                           shrinkWrap: true,
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           children: <Widget>[
//                                             Container(
//                                               transform:
//                                                   Matrix4.translationValues(
//                                                       5.0, 0.0, 0.0),
//                                               child: Text(
//                                                 "Service Type",
//                                                 style: TextStyle(
//                                                     color: Color(0xFFb3b3b3),
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w600,
//                                                     fontFamily: 'Montserrat'),
//                                               ),
//                                             ),
//                                             Visibility(
//                                               visible:
//                                                   upcomingorderdataList[index]
//                                                       .serlistvisible,
//                                               child: Container(
//                                                 margin:
//                                                     EdgeInsets.only(left: 5),
//                                                 child: Text(
//                                                   upcomingorderdataList[index]
//                                                       .services[0]
//                                                       .name,
//                                                   style: TextStyle(
//                                                       color: Color(0xFF4b4b4b),
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontFamily: 'Montserrat'),
//                                                 ),
//                                               ),
//                                             ),
//                                             Visibility(
//                                               visible:
//                                                   upcomingorderdataList[index]
//                                                       .seeallvisible,
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     upcomingorderdataList[index]
//                                                         .seeallvisible = false;
//                                                     upcomingorderdataList[index]
//                                                         .serlistvisible = false;
//                                                     upcomingorderdataList[index]
//                                                         .newlistvisible = true;
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   margin: EdgeInsets.only(
//                                                       left: 5, top: 5),
//                                                   child: Text(
//                                                     "see all...",
//                                                     style: TextStyle(
//                                                         color:
//                                                             Color(0xFF4a92ff),
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         fontFamily:
//                                                             'Montserrat'),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Visibility(
//                                               visible:
//                                                   upcomingorderdataList[index]
//                                                       .newlistvisible,
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     print("sellallTap");
//                                                     upcomingorderdataList[index]
//                                                         .seeallvisible = true;
//                                                     upcomingorderdataList[index]
//                                                         .serlistvisible = true;
//                                                     upcomingorderdataList[index]
//                                                         .newlistvisible = false;
//                                                   });
//                                                 },
//                                                 child: ListView(
//                                                   shrinkWrap: true,
//                                                   physics:
//                                                       NeverScrollableScrollPhysics(),
//                                                   children: <Widget>[
//                                                     Container(
//                                                       margin: EdgeInsets.only(
//                                                           left: 5, top: 5),
//                                                       child: Text(
//                                                         upcomingServiceList
//                                                             .join(" , "),
//                                                         maxLines: 5,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: TextStyle(
//                                                             color: Color(
//                                                                 0xFF4b4b4b),
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             fontFamily:
//                                                                 'Montserrat'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         // height: 100.0,
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.4,
//                                         height: 50,
//                                         alignment: Alignment.topRight,
//                                         margin:
//                                             EdgeInsets.only(top: 20, right: 10),
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // showcancledialog(context,upcomingorderdataList[index].id);
//                                             showcancledialog1(
//                                                 upcomingorderdataList[index].id,
//                                                 screenHeight * 0.3);
//                                           },
//                                           child: RichText(
//                                             text: TextSpan(
//                                               children: [
//                                                 WidgetSpan(
//                                                   child: Container(
//                                                       margin: EdgeInsets.only(
//                                                           top: 5),
//                                                       child: Text("Delete")),
//                                                 ),
//                                                 WidgetSpan(
//                                                   child: Container(
//                                                     margin: EdgeInsets.only(
//                                                         top: 5, left: 5),
//                                                     child: Text(
//                                                         "Cancel Booking",
//                                                         style: TextStyle(
//                                                             color: const Color(
//                                                                 0xFFff4040),
//                                                             fontSize: 12,
//                                                             fontFamily:
//                                                                 'Montserrat',
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w700)),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Visibility(
//                       visible: noupdatavisible,
//                       child: Center(
//                         child: Container(
//                             width: screenwidth,
//                             height: screenHeight * 0.75,
//                             alignment: Alignment.center,
//                             child: ListView(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               children: <Widget>[
//                                 Image.asset(
//                                   "images/nodata.png",
//                                   alignment: Alignment.center,
//                                   width: 150,
//                                   height: 100,
//                                 ),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     "You haven't any appointment set",
//                                     style: TextStyle(
//                                         color: Color(0xFFa3a3a3),
//                                         fontFamily: 'Montserrat',
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ScheduleWidget(),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(top: 5),
//                                       child: Text(
//                                         "Go to Home",
//                                         style: TextStyle(
//                                             color: Color(0xFF4a92ff),
//                                             fontFamily: 'Montserrat',
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 16),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void showcancledialog1(int id, height) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Padding(
//             padding:
//                 const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 20),
//             child: Container(
//               height: height,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Cancel Appointment!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       fontFamily: 'Montserrat',
//                     ),
//                   ),
//                   SizedBox(
//                     height: height * .12,
//                   ),
//                   Divider(
//                     thickness: 1,
//                     color: Color(0xffcccccc),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: height * 0.24,
//                       ),
//                       Text(
//                         'Are you sure you want to cancel your appointment?',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: 'Montserrat',
//                             color: Colors.black54),
//                       ),
//                       SizedBox(
//                         height: height * 0.24,
//                       ),
//                       Divider(
//                         thickness: 1,
//                         color: Color(0xffcccccc),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "No",
//                                 style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     fontFamily: 'Montserrat'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
