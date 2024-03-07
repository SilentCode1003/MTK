import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/attendance.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:intl/intl.dart';
import 'package:eportal/component/developer_options_checker.dart';



class Attendance extends StatefulWidget {
  final String employeeid;

  const Attendance({super.key, required this.employeeid});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String _formatDate(String? date) {
    if (date == "" || date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy', 'en_US').format(dateTime);
  }

  String _formatTime(String? time) {
    if (time == "" || time == null) return '--:--';
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    String formattedTime =
        DateFormat.jm().format(dateTime); // Format time as 4:00 PM
    return formattedTime;
  }

  Helper helper = Helper();
  List<AttendanceModel> usersattendance = [];

  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    _getAttendance();
    super.initState();
    _checkDeveloperOptions();
  }

      void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }


  Future<void> _getAttendance() async {
    final response = await UserAttendance().getattendance(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var attendanceinfo in json.decode(jsondata)) {
        setState(() {
          AttendanceModel userattendance = AttendanceModel(
            attendanceinfo['employeeid'],
            _formatDate(attendanceinfo['attendancedatein']),
            _formatDate(attendanceinfo['attendancedateout']),
            attendanceinfo['geofencenameIn'].toString(),
            attendanceinfo['geofencenameOut'] ?? '--:--',
            _formatTime(attendanceinfo['clockin']),
            _formatTime(attendanceinfo['clockout']),
            attendanceinfo['geofencename'] ?? '--:--',
            attendanceinfo['devicein'],
            attendanceinfo['deviceout'] ?? '--:--',
            attendanceinfo['totalhours'] ?? '--:--',
          );
          usersattendance.add(userattendance);
        });
      }
    }
  }

  Future<void> _filterAttendance() async {
    final response = await UserAttendance().filterattendance(widget.employeeid);

    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);

      usersattendance.clear();

      for (var attendanceinfo in json.decode(jsondata)) {
        DateTime attendanceDate =
            DateTime.parse(attendanceinfo['attendancedatein']);

        if (selectedDateRange == null ||
            (attendanceDate.isAfter(
                    selectedDateRange!.start.subtract(Duration(days: 1))) &&
                attendanceDate
                    .isBefore(selectedDateRange!.end.add(Duration(days: 1))))) {
          setState(() {
            AttendanceModel userattendance = AttendanceModel(
              attendanceinfo['employeeid'],
              _formatDate(attendanceinfo['attendancedatein']),
              _formatDate(attendanceinfo['attendancedateout']),
              attendanceinfo['geofencenameIn'].toString(),
              attendanceinfo['geofencenameOut'] ?? '--:--',
              _formatTime(attendanceinfo['clockin']),
              _formatTime(attendanceinfo['clockout']),
              attendanceinfo['geofencename'] ?? '--:--',
              attendanceinfo['devicein'],
              attendanceinfo['deviceout'] ?? '--:--',
              attendanceinfo['totalhours'] ?? '--:--',
            );
            usersattendance.add(userattendance);
          });
        }
      }
    }
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
        });

    if (picked?.start != null && picked?.end != null) {
      setState(() {
        selectedDateRange = picked;
        usersattendance.clear();
      });

      _filterAttendance();
    }
  }

  Future<void> showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
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
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
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
                child: usersattendance.isEmpty
                    ? Center(
                        child: Text(
                          'No Attendance',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        itemCount: usersattendance.length,
                        itemBuilder: (context, index) {
                          AttendanceModel userAttendance =
                              usersattendance[index];

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
                                  return SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              'Time Tracking',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.timer),
                                            title: Text(
                                              'Clock In:  ${usersattendance[index].clockin} ${usersattendance[index].attendancedateIn}',
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.timer_off),
                                            title: Text(
                                              'Clock Out:  ${usersattendance[index].clockout} ${usersattendance[index].attendancedateOut}',
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.location_city),
                                            title: Text(
                                              'Location In:  ${usersattendance[index].geofencenameIn}',
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.location_city),
                                            title: Text(
                                              'Location Out:  ${usersattendance[index].geofencenameOut}',
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.phone_android),
                                            title: Text(
                                              'Device:  ${usersattendance[index].devicein}',
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.access_time),
                                            title: Text(
                                              'Total Hours:  ${usersattendance[index].totalhours}',
                                            ),
                                          ),
                                        ],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8.0, 20.0, 8.0, 1.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  userAttendance
                                                          .attendancedateIn
                                                          .split(' ')[
                                                      0], // Extracting the day part
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  userAttendance
                                                          .attendancedateIn
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 15),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.0),
                                                  child: Text(
                                                    'Time In',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${userAttendance.clockin}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
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
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.0),
                                                  child: Text(
                                                    'Time Out',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${userAttendance.clockout}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
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
}
