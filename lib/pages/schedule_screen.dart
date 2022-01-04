import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:power_hour_flutter/api/authentication_service.dart';
import 'package:power_hour_flutter/api/repository.dart';
import 'package:power_hour_flutter/model/appconstant.dart';
import 'package:power_hour_flutter/model/time_data.dart';
// import 'package:power_hour_flutter/mukera/booking_screen.dart';
import 'package:power_hour_flutter/styles/theme.dart';
import 'package:power_hour_flutter/utils/toast.dart';
import 'package:power_hour_flutter/widgets/host_meeting_card.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  ScheduleWidget({Key? key, this.parentScaffoldKey})
      : super(key: key);
  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends StateMVC<ScheduleWidget> {
  bool timeVisible = false;
  var timenotVisible = true;
  DateTime selectedDay = DateTime.now();
  var date;
  var currentSelectedIndex;
  List<String> _selecteServicesName = List<String>.empty(growable: true);
  bool viewVisible1 = true;
  var emplist = List.empty(growable: true);
  String? time;
  var selectedempid;
  var salonId;
  var salonData;

  void showWidget() {
    setState(() {
      viewVisible = true;
      viewVisible1 = true;
    });
  }

  bool viewVisible = false;
  void callApiforEmpData() {
    // pr.hide();
     Repository().selectemp(time, date).then((response) {
      setState(() {
        print(response);
        // pr.hide();
        if (response!.success = true) {
          // pr.hide();

          if (response.data!.length > 0) {
            viewVisible = true;
            showWidget;

            emplist.addAll(response.data!);
          } else {
            viewVisible = false;
          }

          // pr.hide();
        } else if (response.success == false) {
          // pr.hide();
          AppConstant.toastMessage(response.msg!);
        }
      });
    }).catchError((Object obj) {
      // pr.hide();
      AppConstant.toastMessage("No employee available at this time");
    });
  }

  void callApiForBookService() async {
    Repository()
        .booking(
      selectedempid.toString(),
      date.toString(),
      time.toString(),
    )
        .then((response) {
      setState(() {
        if (response!.success = true) {
          toastMessage("Booked Successfully");
        } else {
          toastMessage("No Data");
        }
      });
    }).catchError((Object obj) {
      print("bookinresponse_error:${obj.toString()}");
      //AppConstant.toastMessage("Internal Server Error");
    });
  }

  Repository? repository;
// void callApiforgettimeslot(date)async {
//     TimeDataResponseModel? userServerData = await repository!.timeslot(1, date.toString());

// }

  void callApiforgettimeslote(date) {
    print("new $date.toString");

    Repository()
        .timeslot(
      date,
    )
        .then((response) {
      print("here $response");
      setState(() {
        if (response != null) {
          timelist.clear();
          timeVisible = true;
          timenotVisible = false;
          timelist.addAll(response.data!);
        }
        // pr.hide();

        else {
          timeVisible = false;
          timenotVisible = true;
          viewVisible = false;
          AppConstant.toastMessage(response!.msg!);
        }
      });
    }).catchError((Object obj) {
      NullThrownError();
      // pr.hide();
      timelist.clear();
      timeVisible = false;
      timenotVisible = true;
      viewVisible = false;
    });
  }

  List<TimeData> timelist = List<TimeData>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;

    var therapistDisplay = GestureDetector(
      child: Visibility(
        visible: viewVisible,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Container(
          // height: screenHeight * 0.25,
          margin: EdgeInsets.only(bottom: 150),
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  bottom: 00.0,
                  left: 20.0,
                  right: 0.0,
                ),
                child: Text(
                  "Select Therapist",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
              Container(
                // height: screenHeight * 0.25,
                margin:
                    EdgeInsets.only(top: 0.0, left: 10, right: 10, bottom: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: emplist.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var color = emplist[index].isSelected
                        ? Color(0xFFe06287)
                        : Color(0xFFa5a5a5);

                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          // String name = Repository().userBox.get('userId');
                          

                          // print("Name is $name");
                          emplist
                              .forEach((element) => element.isSelected = false);
                          emplist[index].isSelected = true;
                          selectedempid = emplist[index].empId;
                          print("EmpId123:$selectedempid");

                          viewVisible1 = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(left: 20, top: 5),
                              width: 20,
                              height: 20,
                              color: Colors.white,
                              child: Container(
                                  width: 15,
                                  height: 15,
                                  child: GestureDetector(
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: color,
                                        border: Border.all(
                                          color: const Color(0xFFdddddd),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: emplist[index].isSelected
                                            ? Icon(
                                                Icons.check,
                                                size: 15.0,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons
                                                    .check_box_outline_blank_outlined,
                                                size: 15.0,
                                                color: color,
                                              ),
                                      ),
                                    ),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 5),
                              height: 35,
                              width: 35,
                              alignment: Alignment.topLeft,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              height: 50,
                              // margin: EdgeInsets.only(left: 10,top: 10),
                              // width: double.infinity,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .65,
                                    height: 30,
                                    margin: EdgeInsets.only(
                                        left: 1, top: 2, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            emplist[index].name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .65,
                                    height: 10,
                                    margin: EdgeInsets.only(
                                        left: 1, top: 8, right: 10),
                                    child: MySeparator(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    var elements = <Widget>[
      Container(
        padding: EdgeInsets.all(50),
        child: Text(
          "Schedule Therapy",
          style: TextStyle(fontSize: 25),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: CustomTheme.boxShadow,
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
          top: 1.0,
          left: 15,
          right: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //custom icon
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: TableCalendar(
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.now(),
                  focusedDay: DateTime.now(),
                  calendarFormat: CalendarFormat.week,
                  lastDay: DateTime(2023),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.grey),
                    selectedTextStyle: TextStyle(color: Colors.blue[400]),
                    todayTextStyle: TextStyle(color: Colors.blue[50]),
                    outsideDaysVisible: false,
                    outsideTextStyle: TextStyle(color: Colors.black),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    headerPadding: EdgeInsets.only(left: 0),
                    formatButtonVisible: false,
                    formatButtonTextStyle: TextStyle()
                        .copyWith(color: Colors.black, fontSize: 15.0),
                  ),
                  onDaySelected: (DateTime day, DateTime anotherArg) {
                    setState(
                      () {
                        selectedDay = day;
                        var myFormat = DateFormat('yyyy-MM-dd');
                        date = myFormat.format(selectedDay);
                        toastMessage("DaySelected $date");
                        // if (mounted) {
                        print(date);
                        // if (date == null) {
                        //   callApiforgettimeslote(date);
                        // }
                        // else{
                        callApiforgettimeslote(date);
                        // }
                        // }
                      },
                    );
                    // setState(() {
                    //   timelist.clear();
                    //   timeVisible = true;
                    //   timenotVisible = false;
                    //   // timelist.addAll(timedatalist);
                    // }
                    // pr.hide();
                    // );
                  }

                  // onCalendarCreated: _onCalendarCreated,
                  ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        margin: EdgeInsets.only(
          left: 20.0,
        ),
        child: Text(
          "Select The Time",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      ),
      Visibility(
        visible: timeVisible,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: CustomTheme.boxShadow,
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: 5.0, left: 15, right: 15, bottom: 10),
            height: screenHeight * 0.25,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: timelist.length,
              itemBuilder: (context, index) {
                bool isSelected = currentSelectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        emplist.clear();
                        currentSelectedIndex = index;
                        time = (timelist[index].startTime);
                        var myFormat = DateFormat('yyyy-MM-dd');
                        date = myFormat.format(selectedDay);
                        viewVisible1 = true;
                        callApiforEmpData();
                      },
                    );
                    
                  },
                  child: Container(
                    margin: EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: null,
                      child: Text(
                        timelist[index].startTime,
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      color: Colors.white,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: const Color(0xFF4a92ff),
                            border: Border.all(
                              color: const Color(0xFF4a92ff),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : BoxDecoration(),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 6),
                crossAxisCount: 4,
                mainAxisSpacing: 1,
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: timenotVisible,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "Select Date to see available time slots",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      therapistDisplay
    ];
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: elements,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: viewVisible1,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 50),
                    color: Colors.white,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 15),
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            onPressed: () {
                              callApiForBookService();
                            },
                            child: Text("Schedule"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ], // new Container(child: Body(viewVisible))],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = const Color(0xFFdddddd)});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
