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
import 'package:eportal/model/internet_checker.dart';
import 'dart:io';


class Index extends StatefulWidget {
  final String employeeid;
  final int department;
  const Index({
    Key? key,
    required this.employeeid,
    required this.department,
  }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  String ma_clockin = '';
  String ma_clockout = '';
  DateTime clockOutDate = DateTime.now();
  DateTime clockOutDateTime = DateTime.now();
  DateTime clockInDateTime = DateTime.now();

  String _formatTime(String? time) {
    print(time);
    if (time == "" || time == null) return '--:--';
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    String formattedTime =
        DateFormat.jm().format(dateTime); // Format time as 4:00 PM
    return formattedTime;
  }

  Helper helper = Helper();

  List<TodayModel> todaystatus = [];

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
  int department = 0;

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
    _getUserInfo();

    // fetchLocation();
    super.initState();
  }
  Future<void> checkLocationService() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, show alert dialog
    showLocationServiceAlertDialog();
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return;
  }

  if (permission == LocationPermission.denied) {
    // Permissions are denied, request permissions.
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      // Permissions are denied, display an error message.
      return;
    }
  }
  // Permissions are granted, continue fetching location.
}

void showLocationServiceAlertDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Location Services Disabled'),
        content: Text('Please enable location services to use this app.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Open Location Settings'),
            onPressed: () {
              // Open device settings to enable location services
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
        print(statusinfo);
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
        userinfo['department'],
        userinfo['departmentname'],
        userinfo['position'],
        userinfo['jobstatus'],);

    setState(() {
      employeeid = user.employeeid;
      department = user.department;

      _getGeofence();
      _getLatesLog();
      _getStatus();
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
      final results = await Geofence().getfence('$department');
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
    }
  }

  Future<void> _getCurrentLocation() async {
    getCurrentLocation().then((Position position) {
      // Use the position data
      double latitude = position.latitude;
      double longitude = position.longitude;
      // Do something with the latitude and longitude

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
      }
    }).catchError((e) {
      // Handle error scenarios
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
      // showNotifications = false;
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
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _clockout(widget.employeeid, _latitude, _longitude);
                    // setState(() {
                    //   isLoggedIn = false;
                    //   timestatus = 'Time In';
                    // });

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Log Out'))
            ],
          );
        });
  }
void showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Close the app when Log Out button is pressed
              if (Platform.isAndroid || Platform.isIOS) {
                exit(0);
              }
            },
            child: const Text('Log Out'),
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
        // Enable the "Status" button
        setState(() {
          print('true');
          isStatusButtonEnabled = true;
        });
      }
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verify Location'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: activelocation,
                  zoom: zoomLevel.level,
                  onTap: (point, activelocation) {
                    // _selectLocation(latLng);

                    // Check if the selected location is inside circledomain, circledomaintwo, or thirdcircle
                  },
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
                          child: const Icon(Icons.location_pin,
                              color: Colors.red, size: 40.0))
                    ],
                  ),
                  for (GeofenceModel fence in geofence)
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(fence.latitude, fence.longitude),
                          color: Colors.green.withOpacity(0.5), // Fill color
                          borderColor: Colors.blue, // Border color
                          borderStrokeWidth: 2, // Border width
                          useRadiusInMeter: true,
                          radius: fence.radius, // Radius in meters
                        ),
                      ],
                    ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: isStatusButtonEnabled
                      ? () {
                          print('isLogin $isLoggedIn');
                          if (isLoggedIn) {
                            showLogoutDialog();
                          } else {
                            _clockin(widget.employeeid, _latitude, _longitude);
                            // setState(() {
                            //   isLoggedIn = true;
                            //   timestatus = 'Time Out';
                            // });
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  child: const Text('Confirm')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  Future<void> _clockin(employeeid, latitude, longitude) async {
    try {
      final results = await UserAttendance()
          .clockin(employeeid, latitude.toString(), longitude.toString());

      print(results);

      if (results.message == Helper().getStatusString(APIStatus.success)) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Clock In successful!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${DateFormat('MMM dd, yyyy').format(clockInDateTime)}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    '${DateFormat('h:mm:ss a').format(clockInDateTime)}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),Center(
                  child: Text(
                    'Time in Main Office'
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx); // Close the dialog
                      setState(() {
                        isLoggedIn = true;
                        timestatus = 'Time Out';
                      });
                      _getStatus();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
            title: Text('$timestatus'),
            content: const Text('Tama kana may bukas pa!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _getStatus();
                  setState(() {
                    isLoggedIn = false;
                    timestatus = 'Time In';
                  });
                },
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
            content: Text('Clock IN $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _clockout(employeeid, latitude, longitude) async {
    try {
      final results = await UserAttendance()
          .clockout(employeeid, latitude.toString(), longitude.toString());

      if (results.message == Helper().getStatusString(APIStatus.success)) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Clock out successful!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${DateFormat('MMM dd, yyyy').format(clockOutDateTime)}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    '${DateFormat('h:mm:ss a').format(clockInDateTime)}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx); // Close the dialog
                      setState(() {
                        isLoggedIn = false;
                        timestatus = 'Time In';
                      });
                      _getStatus();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                  Navigator.pop(context); // Close the dialog
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

  void _reloadPage() {
    Navigator.pop(context); // Pop the current page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Index(
          employeeid: widget.employeeid,
          department: widget.department,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM d yyyy').format(now);

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
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Status",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'NexaRegular',
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'Time In',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$ma_clockin',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 50),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'Time Out',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$ma_clockout',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<String>(
                        stream: currentTimeStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final now = DateTime.now();
                            final formattedTime =
                                DateFormat('E, MMM d • h:mm:ss a').format(now);
                            return Column(
                              children: [
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return currentLocation.isEmpty
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      height: 22, // Adjust the height as needed
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  )
                                : SizedBox
                                    .shrink(); // This will create an empty/hidden widget
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: currentLocation.isEmpty
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 55, // Adjust the height as needed
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        : Text(
                            currentLocation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        verifylocation();
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Colors.white, // Set the background color to white
                          border: Border.all(
                            color: isLoggedIn ? Colors.red : Colors.green,
                            width: 3, // Adjust the border width as needed
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Add your timeout icon here
                            Icon(
                              Icons.alarm,
                              color: isLoggedIn ? Colors.red : Colors.green,
                              size: 80,
                            ),
                            SizedBox(
                              height: 10,
                            ), // Adjust the spacing between the icon and text as needed
                            Center(
                              child: Text(
                                timestatus,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isLoggedIn ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
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
