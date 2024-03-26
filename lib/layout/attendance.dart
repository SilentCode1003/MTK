import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/attendance.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:intl/intl.dart';
import 'package:eportal/component/developer_options_checker.dart';
import 'package:eportal/layout/notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:eportal/api/notification.dart';

class Attendance extends StatefulWidget {
  final String employeeid;

  const Attendance({super.key, required this.employeeid});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String UnreadCount = '1';
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

  String _formatDate1(DateTime? date) {
    if (date == null) return ''; // Return an empty string if date is null
    return DateFormat('dd MMM yyyy', 'en_US').format(date);
  }

  Helper helper = Helper();
  List<AttendanceModel> usersattendance = [];
  List<NotificationBadges> notificationbadges = [];

  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    _getAttendance();
    super.initState();
    _checkDeveloperOptions();
    _getBadges();
    widget.employeeid;
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

  Future<void> _getBadges() async {
    final response =
        await UserNotifications().getnotificationbadges(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var badgesinfo in json.decode(jsondata)) {
        setState(() {
          NotificationBadges notificationbadgesinfo = NotificationBadges(
            badgesinfo['Unreadcount'].toString(),
          );
          UnreadCount = notificationbadgesinfo.Unreadcount;
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
            (attendanceDate.isAfter(selectedDateRange!.start
                    .subtract(const Duration(days: 1))) &&
                attendanceDate.isBefore(
                    selectedDateRange!.end.add(const Duration(days: 1))))) {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Attendance', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(right: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
                badgeContent: Text(
                  UnreadCount,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 25.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Notifications(
                          employeeid: widget.employeeid,
                        ),
                      ),
                    );
                  },
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.76,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: usersattendance.isEmpty
                    ? Center(
                        child: Text(
                          "No Attendance",
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
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            child: const Text(
                                              'Time Tracking',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.timer),
                                            title: Text(
                                              'Clock In:  ${usersattendance[index].clockin} ${usersattendance[index].attendancedateIn}',
                                            ),
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.timer_off),
                                            title: Text(
                                              'Clock Out:  ${usersattendance[index].clockout} ${usersattendance[index].attendancedateOut}',
                                            ),
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.location_city),
                                            title: Text(
                                              'Location In:  ${usersattendance[index].geofencenameIn}',
                                            ),
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.location_city),
                                            title: Text(
                                              'Location Out:  ${usersattendance[index].geofencenameOut}',
                                            ),
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.phone_android),
                                            title: Text(
                                              'Device:  ${usersattendance[index].devicein}',
                                            ),
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.access_time),
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
                                      decoration: const BoxDecoration(
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
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 14.0, 8.0, 2.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  userAttendance
                                                      .attendancedateIn
                                                      .split(' ')[0],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  userAttendance
                                                      .attendancedateIn
                                                      .split(' ')[1],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
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
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 15),
                                                const Padding(
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
                                                  userAttendance.clockin,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 40),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 15),
                                                const Padding(
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
                                                  userAttendance.clockout,
                                                  style: const TextStyle(
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
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                _showDateRangePicker(context);
              },
              child: Icon(
                Icons.calendar_today_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
