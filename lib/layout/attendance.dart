import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/attendance.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  final String employeeid;

  const Attendance({super.key, required this.employeeid});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy', 'en_US').format(dateTime);
  }

  Helper helper = Helper();
  List<AttendanceModel> usersattendance = [];

  @override
  void initState() {
    _getAttendance();
    super.initState();
  }

  Future<void> _getAttendance() async {
    final response = await UserAttendance().getattendance(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var attendanceinfo in json.decode(jsondata)) {
        setState(() {
          AttendanceModel userattendance = AttendanceModel(
            attendanceinfo['employeeid'],
            _formatDate(attendanceinfo['attendancedate']),
            attendanceinfo['clockin'],
            attendanceinfo['clockout'],
            attendanceinfo['devicein'],
            attendanceinfo['deviceout'],
            attendanceinfo['totalhours'],
          );
          usersattendance.add(userattendance);
        });
      }
      print(usersattendance[0].employeeid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Attendance',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDateRangePicker(context);
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, -2),
                      blurRadius: 5.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: usersattendance.length,
                  itemBuilder: (context, index) {
                    AttendanceModel userAttendance = usersattendance[index];

                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Attendance',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 20.0, 8.0, 1.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            userAttendance.attendancedate
                                                    .split(' ')[
                                                0], // Extracting the day part
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            userAttendance.attendancedate
                                                    .split(' ')[
                                                1], // Extracting the month part
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  20, // You can adjust the font size for the month
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              'Time In',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                '${userAttendance.clockin}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 40),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 15),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              'Time Out',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${userAttendance.clockout}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 215, 36, 24),
            colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 215, 36, 24)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked?.start != null && picked?.end != null) {
      print('Selected date range: ${picked!.start} to ${picked.end}');
    }
  }
}
