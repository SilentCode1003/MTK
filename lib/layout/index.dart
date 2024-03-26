import 'dart:convert';
import 'package:eportal/api/attendance.dart';
import 'package:eportal/api/geofence.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/geolocation.dart';
import 'package:eportal/repository/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
import 'package:eportal/api/todaystatus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eportal/component/internet_checker.dart';
import 'dart:io';
import 'package:eportal/component/developer_options_checker.dart';
import 'dart:async';
import 'package:eportal/layout/notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:eportal/api/notification.dart';

class Index extends StatefulWidget {
  final String employeeid;
  final int departmentid;
  const Index({
    Key? key,
    required this.employeeid,
    required this.departmentid,
  }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  String UnreadCount = '1';
  String ma_clockin = '';
  String ma_clockout = '';
  DateTime clockOutDate = DateTime.now();
  DateTime clockOutDateTime = DateTime.now();
  DateTime clockInDateTime = DateTime.now();
  String image = '';
  String fullname = '';
  String _formatTime(String? time) {
    if (time == "" || time == null) return '--:--';
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    String formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Helper helper = Helper();

  List<TodayModel> todaystatus = [];
  List<NotificationBadges> notificationbadges = [];

  String currentLocation = '';
  String timestatus = 'Time In';
  bool isInPressed = false;
  bool isLoggedIn = false;

  double _latitude = 0;
  double _longitude = 0;

  double _latitudeFence = 14.3379337;
  double _longitudeFence = 121.0604765;

  List<Widget> notifications = [];
  bool showNotifications = false;

  LatLng manuallySelectedLocation = const LatLng(14.3390743, 121.0610688);
  MapController mapController = MapController();
  ZoomLevel zoomLevel = ZoomLevel(17.5);
  bool isStatusButtonEnabled = false;

  List<GeofenceModel> geofence = [];
  List<Widget> geofencemarker = [];
  List<AttendanceLog> attendancelogs = [];

  String employeeid = '';
  int departmentid = 0;
  int _geofenceid = 0;
  String devicein = '';
  String deviceout = '';
  String _geofencename = '';

  @override
  void initState() {
    getCurrentLocation().then((Position position) {
      double latitude = position.latitude;
      double longitude = position.longitude;

      setState(() {
        _latitude = latitude;
        _longitude = longitude;
        _latitudeFence = latitude;
        _longitudeFence = longitude;
      });

      getGeolocationName(latitude, longitude)
          .then((locationname) => {
                setState(() {
                  currentLocation = locationname;
                })
              })
          .catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
      });
    });

    checkLocationService();
    _checkDeveloperOptions();
    _getUserInfo();
    super.initState();
  }

  Future<void> checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationServiceAlertDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
  }

  void showLocationServiceAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content:
              const Text('Please enable location services to use this app.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Location Settings'),
              onPressed: () {
                Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getStatus() async {
    final response =
        await Status().getstatus(employeeid, helper.GetCurrentDate());
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      if (jsondata.length == 2) {
        setState(() {
          ma_clockin = '--:--';
          ma_clockout = '--:--';
        });
      }
      for (var statusinfo in json.decode(jsondata)) {
        setState(() {
          ma_clockin = _formatTime(statusinfo['logtimein']);
          ma_clockout = _formatTime(statusinfo['logtimeout']);
        });
      }
    }
  }

  Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo =
        await Helper().readJsonToFile('metadata.json');
    UserInfoModel user = UserInfoModel(
      userinfo['image'],
      userinfo['employeeid'],
      userinfo['fullname'],
      userinfo['accesstype'],
      userinfo['departmentid'],
      userinfo['departmentname'],
      userinfo['position'],
      userinfo['jobstatus'],
    );

    setState(() {
      employeeid = user.employeeid;
      departmentid = user.departmentid;
      image = user.image;
      fullname = user.fullname;

      _getGeofence();
      _getLatesLog();
      _getStatus();
      _getBadges();
    });
  }

  Future<void> _getLatesLog() async {
    try {
      final results = await UserAttendance().getlateslog(employeeid);
      final jsonData = json.encode(results.result);
      setState(() {
        for (var log in json.decode(jsonData)) {
          attendancelogs.add(AttendanceLog(
              log['logid'],
              log['attendanceid'],
              log['employeeid'],
              log['longdatetime'],
              log['logtype'],
              log['latitude'],
              log['longitude'],
              log['device']));
        }

        for (AttendanceLog attendance in attendancelogs) {
          if (attendance.logtype == Helper().getLogtype(Logtype.clockin)) {
            isLoggedIn = true;
            timestatus = 'Time Out';
          } else {
            isLoggedIn = false;
            timestatus = 'Time In';
          }
        }
      });

      print(isLoggedIn);
    } catch (e) {
      print('Latest Log $e');
    }
  }

  Future<void> _getGeofence() async {
    try {
      final results = await Geofence().getfence('$departmentid');
      final jsonData = json.encode(results.result);
      setState(() {
        for (var setting in json.decode(jsonData)) {
          geofence.add(GeofenceModel(
            setting['geofenceid'],
            setting['geofencename'],
            setting['departmentid'],
            setting['latitude'],
            setting['longitude'],
            setting['radius'],
            setting['location'],
            setting['status'],
          ));
        }
      });
    } catch (e) {
      print('Geofence $e');
      print('ito and geofence');
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

  Future<void> _getCurrentLocation() async {
    getCurrentLocation().then((Position position) {
      double latitude = position.latitude;
      double longitude = position.longitude;

      setState(() {
        _latitude = latitude;
        _longitude = longitude;
      });

      getGeolocationName(latitude, longitude)
          .then((locationname) => {
                setState(() {
                  currentLocation = locationname;
                })
              })
          .catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
      });

      if (kDebugMode) {
        print('Latitude: $latitude, Longitude: $longitude');
        print(_geofenceid);
      }
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  void addNotification(Widget notification) {
    setState(() {
      notifications.insert(0, notification);
    });
  }

  void removeNotification(Widget notification) {
    setState(() {
      notifications.remove(notification);
    });
  }

  void clearNotifications() {
    setState(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          notifications.clear();
        });
      });
    });
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: const Center(
            child: Text(
              'Are you sure you want to clock out?',
              style: TextStyle(fontSize: 14),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            SizedBox(
              width: 120,
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              width: 130,
              height: 40,
              child: TextButton(
                onPressed: () {
                  _clockout(widget.employeeid, _latitude, _longitude,
                      _geofenceid, deviceout);
                  // setState(() {
                  //   isLoggedIn = false;
                  //   timestatus = 'Time In';
                  // });

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: const Center(
            child: Text(
              'Are you sure you want to exit?',
              style: TextStyle(fontSize: 15),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            SizedBox(
              width: 120,
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              width: 130,
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid || Platform.isIOS) {
                    exit(0);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void verifylocation() async {
    await _getCurrentLocation();

    LatLng activelocation = LatLng(_latitude, _longitude);
    for (GeofenceModel fence in geofence) {
      LatLng circledomain = LatLng(fence.latitude, fence.longitude);
      final distanceToDomain =
          const Distance().as(LengthUnit.Meter, circledomain, activelocation);
      if (distanceToDomain <= fence.radius) {
        setState(() {
          print('true');
          isStatusButtonEnabled = true;
          _geofenceid = fence.geofenceid;
          _geofencename = fence.geofencename;
        });
      }
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Stream<String> currentTimeStream =
            Stream.periodic(const Duration(seconds: 1), (int _) {
          final now = DateTime.now();
          return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
        });
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 190,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 100,
                              child: FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  center: activelocation,
                                  zoom: zoomLevel.level,
                                  onTap: (point, activelocation) {},
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: const ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: activelocation,
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.memory(
                                              base64Decode(image),
                                              width: 40.0,
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  for (GeofenceModel fence in geofence)
                                    CircleLayer(
                                      circles: [
                                        CircleMarker(
                                          point: LatLng(
                                              fence.latitude, fence.longitude),
                                          color: Colors.green.withOpacity(0.5),
                                          borderColor: Colors.green,
                                          borderStrokeWidth: 2,
                                          useRadiusInMeter: true,
                                          radius: fence.radius,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 40.0,
                    left: 16.0,
                    child: SizedBox(
                      width: 100.0,
                      height: 35.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 8.0),
                            Icon(Icons.arrow_back, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 270,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        _geofencename.isNotEmpty
                            ? Center(
                                child: Text(
                                  _geofencename,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'Please move to your assigned location',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100.0,
                                  width: 175.0,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 15.0,
                                          top: 1,
                                        ),
                                        child: Text(
                                          ma_clockin,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 15.0,
                                        ),
                                        child: Text(
                                          'Time In',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100.0,
                                  width: 175.0,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 15.0,
                                          top: 1,
                                        ),
                                        child: Text(
                                          ma_clockout,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: EdgeInsets.only(right: 15.0),
                                        child: Text(
                                          'Time Out',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        ElevatedButton(
                          onPressed: isStatusButtonEnabled
                              ? () {
                                  print('isLogin $isLoggedIn');
                                  if (isLoggedIn) {
                                    showLogoutDialog();
                                  } else {
                                    _clockin(
                                      widget.employeeid,
                                      _latitude,
                                      _longitude,
                                      _geofenceid,
                                      devicein,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(Size(330, 55)),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.black12;
                                }
                                return Colors.white;
                              },
                            ),
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return BorderSide(color: Colors.grey);
                                }
                                return BorderSide(
                                  color: isLoggedIn ? Colors.red : Colors.green,
                                );
                              },
                            ),
                          ),
                          child: Text(
                            timestatus,
                            style: TextStyle(
                                fontSize: 20,
                                color: isStatusButtonEnabled
                                    ? isLoggedIn
                                        ? Colors.red
                                        : Colors.green
                                    : Colors.black12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clockin(
      employeeid, latitude, longitude, geofenceid, devicein) async {
    try {
      final results = await UserAttendance().clockin(
          employeeid,
          latitude.toString(),
          longitude.toString(),
          geofenceid.toString(),
          devicein.toString());

      if (results.message == Helper().getStatusString(APIStatus.success)) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Column(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Clock In Successfully',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    '${DateFormat('MMM dd').format(clockInDateTime)} ${DateFormat('h:mm a').format(clockInDateTime)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    _geofencename,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 250,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        isLoggedIn = true;
                        timestatus = 'Time Out';
                      });
                      _getStatus();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 80,
                ),
                SizedBox(height: 5),
                Text(
                  'Already have Attendance',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 250,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _getStatus();
                      setState(() {
                        isLoggedIn = false;
                        timestatus = 'Time In';
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Clock IN $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _clockout(
      employeeid, latitude, longitude, geofenceid, deviceout) async {
    try {
      final results = await UserAttendance().clockout(
          employeeid,
          latitude.toString(),
          longitude.toString(),
          geofenceid.toString(),
          deviceout.toString());

      if (results.message == Helper().getStatusString(APIStatus.success)) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Column(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Clock out Successfully',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    '${DateFormat('MMM dd').format(clockInDateTime)} ${DateFormat('h:mm a').format(clockInDateTime)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    _geofencename,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 250,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        isLoggedIn = false;
                        timestatus = 'Time In';
                      });
                      _getStatus();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Access'),
            content: const Text('Incorrect username and password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Clock Out $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _getStatus();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    Stream<String> currentTimeStream =
        Stream.periodic(const Duration(seconds: 1), (int _) {
      final now = DateTime.now();
      return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });

    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 65.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.memory(
                            base64Decode(image),
                            fit: BoxFit.cover,
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.0),
                            Text(
                              "Hey Good Day!",
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              fullname,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 167.0),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (UnreadCount != 0)
                                badges.Badge(
                                  badgeContent: Text(
                                    UnreadCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  position: badges.BadgePosition.topEnd(
                                      top: 0, end: 5),
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
                                            employeeid: employeeid,
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
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    top: 150.0,
                    left: 0,
                    right: 0,
                  ),
                  height: 370,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.5),
                    //     spreadRadius: 5,
                    //     blurRadius: 7,
                    //     offset: Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<String>(
                            stream: currentTimeStream,
                            builder: (context, snapshot) {
                              String formattedTime = '';
                              if (snapshot.hasData) {
                                final now = DateTime.now();
                                formattedTime =
                                    DateFormat('hh:mm:ss a').format(now);
                                return Column(
                                  children: [
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      DateFormat('EEEE, MMM d').format(now),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return formattedTime.isEmpty
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              225,
                                          height: 68,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: currentLocation.isEmpty
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 250,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    currentLocation
                                        .split(' ')
                                        .take(4)
                                        .join(' '),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          verifylocation();
                        },
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.alarm,
                                color: isLoggedIn ? Colors.red : Colors.green,
                                size: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                timestatus,
                                style: TextStyle(
                                  color: isLoggedIn ? Colors.red : Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum NotificationType { success, info }

class NotificationCard extends StatelessWidget {
  final String message;
  final NotificationType type;
  final VoidCallback onDismiss;

  const NotificationCard({
    Key? key,
    required this.message,
    required this.type,
    required this.onDismiss,
  }) : super(key: key);

  Color getNotificationColor() {
    switch (type) {
      case NotificationType.success:
        return Colors.green[100]!;
      case NotificationType.info:
        return Colors.blue[100]!;
    }
  }

  Icon getNotificationIcon() {
    switch (type) {
      case NotificationType.success:
        return const Icon(Icons.check, color: Colors.green);
      case NotificationType.info:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getNotificationColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          getNotificationIcon(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

class ZoomLevel {
  double level;
  ZoomLevel(this.level);
}

class GeofenceMarker {
  int radius;
  double latitudefence;
  double longitudefence;

  GeofenceMarker(this.radius, this.latitudefence, this.longitudefence);
}
