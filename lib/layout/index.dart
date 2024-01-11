import 'dart:convert';

import 'package:eportal/api/geofence.dart';
import 'package:eportal/layout/attendance.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/geolocation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Index(
//       fullname: '',
//       employeeid: '',
//     ),
//   ));
// }

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
  String currentLocation = '';
  String timestatus = 'Time In';
  bool isInPressed = false;
  bool isLoggedIn = false;

  double _latitude = 0;
  double _longitude = 0;

  double _latitudeFence = 14.3379337;
  double _longitudeFence = 121.0604765;

  final double _radius = 100;

  List<Widget> notifications = [];
  bool showNotifications = false;

  LatLng manuallySelectedLocation = LatLng(14.3390743, 121.0610688);
  MapController mapController = MapController();
  ZoomLevel zoomLevel = ZoomLevel(17.5);
  bool isStatusButtonEnabled = false;

  List<GeofenceModel> geofence = [];
  List<Widget> geofencemarker = [];

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

                  _getGeofence();
                })
              })
          .catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
      });
    });
    // fetchLocation();
    super.initState();
  }

  // Future<void> fetchLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       currentLocation =
  //           'Lat: ${position.latitude}, Long: ${position.longitude}';
  //     });
  //   } catch (e) {
  //     print('Error fetching location: $e');
  //     setState(() {
  //       currentLocation = 'Location unavailable';
  //     });
  //   }
  // }

  Future<void> _getGeofence() async {
    final results = await Geofence().getfence('${widget.department}');
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

      // for (GeofenceModel fence in geofence) {
      //   LatLng circledomain = LatLng(fence.latitude, fence.longitude);
      //   geofencemarker = List<Widget>.generate(
      //     geofence.length,
      //     (index) => CircleLayer(
      //       circles: [
      //         CircleMarker(
      //           point: circledomain,
      //           color: Colors.green.withOpacity(0.5), // Fill color
      //           borderColor: Colors.blue, // Border color
      //           borderStrokeWidth: 2, // Border width
      //           useRadiusInMeter: true,
      //           radius: geofence[index].radius, // Radius in meters
      //         ),
      //       ],
      //     ),
      //   );
      // }
    });
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
                    Navigator.of(context).pop();
                    setState(() {
                      isLoggedIn = false;
                      timestatus = 'Time In';
                    });

                    addNotification(
                      NotificationCard(
                        message: 'You are logged out!',
                        type: NotificationType.info,
                        onDismiss: () {
                          removeNotification(
                            NotificationCard(
                              message: 'You are logged out!',
                              type: NotificationType.info,
                              onDismiss: () {},
                            ),
                          );
                        },
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('You are logged out!'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('Log Out'))
            ],
          );
        });
  }

  void verifylocation() async {
    await _getCurrentLocation();

    LatLng activelocation = LatLng(_latitude, _longitude);
    LatLng circledomain = LatLng(_latitudeFence, _longitudeFence);
    final distanceToDomain =
        const Distance().as(LengthUnit.Meter, circledomain, activelocation);

    if (distanceToDomain <= _radius) {
      // Enable the "Status" button
      setState(() {
        print('true');
        isStatusButtonEnabled = true;
      });
    } else {
      // Disable the "Status" button
      setState(() {
        print('false');
        isStatusButtonEnabled = false;
      });
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
                          if (isLoggedIn) {
                            showLogoutDialog();
                          } else {
                            setState(() {
                              isLoggedIn = true;
                              timestatus = 'Time Out';

                              addNotification(
                                NotificationCard(
                                  message: 'You are logged in!',
                                  type: NotificationType.success,
                                  onDismiss: () {
                                    removeNotification(
                                      NotificationCard(
                                        message: 'You are logged in!',
                                        type: NotificationType.success,
                                        onDismiss: () {},
                                      ),
                                    );
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('You are logged in!'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            });

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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM d yyyy').format(now);
    // String formattedTime = DateFormat('h:mm a').format(now);

    Stream<String> currentTimeStream =
        Stream.periodic(const Duration(seconds: 1), (int _) {
      final now = DateTime.now();
      return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });

    return Scaffold(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Time In',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8, width: 50),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: Text(
                                    '--/--',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 30),
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
                                '--/--',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$formattedDate',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    StreamBuilder<String>(
                      stream: currentTimeStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final now = DateTime.now();
                          final formattedTime =
                              DateFormat('h:mm:ss a').format(now);
                          return Column(
                            children: [
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    currentLocation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
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
                        color: isLoggedIn ? Colors.red : Colors.green,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Add your timeout icon here
                          Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 80,
                          ),
                          SizedBox(
                              height:
                                  10), // Adjust the spacing between the icon and text as needed
                          Center(
                            child: Text(
                              timestatus,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
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
