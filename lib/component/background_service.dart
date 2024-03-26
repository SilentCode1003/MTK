// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:eportal/model/userinfo.dart';
// import 'package:eportal/api/notification.dart';

// class MyBackgroundService extends StatefulWidget {
//   @override
//   _MyBackgroundServiceState createState() => _MyBackgroundServiceState();
// }

// class _MyBackgroundServiceState extends State<MyBackgroundService> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     initializeNotifications();
//     _startBackgroundService();
//     _checkAndPushNotifications(); // Trigger notification check on app open
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // You don't need any UI for a background service
//   }

//   Future<void> initializeNotifications() async {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _startBackgroundService() async {
//     BackgroundService.initialize(onStart);
//     BackgroundService.sendData({"action": "start"});
//   }

//   void onStart() {
//     WidgetsFlutterBinding.ensureInitialized();

//     BackgroundService.onDataReceived.listen((event) {
//       if (event["action"] == "start") {
//         _checkAndPushNotifications();
//       }
//     });

//     BackgroundService.setForegroundMode(true);
//   }

//   Future<void> _checkAndPushNotifications() async {
//     final response =
//         await UserNotifications().getnotification(widget.employeeid);
//     if (helper.getStatusString(APIStatus.success) == response.message) {
//       final jsondata = json.encode(response.result);
//       for (var pushnotificationinfo in json.decode(jsondata)) {
//         if (pushnotificationinfo['isrecieved'].toString() == 'NO') {
//           await _recievednotification(
//               pushnotificationinfo['notificationid'].toString());
//         }
//       }
//     }
//   }

//   Future<void> _recievednotification(String notificationid) async {
//     try {
//       final response = await UserNotifications().readnotication(notificationid);
//       if (response.status == 200) {
//         final pushnotificationinfo = response.result;
//         setState(() {
//           PushNotifcations pushnotif = PushNotifcations(
//             pushnotificationinfo['notificationid'].toString(),
//             pushnotificationinfo['employeeid'].toString(),
//             _formatDate(pushnotificationinfo['date'].toString()),
//             pushnotificationinfo['tittle'].toString(),
//             pushnotificationinfo['description'],
//             pushnotificationinfo['subdescription'] ?? '',
//             pushnotificationinfo['image'] != null
//                 ? pushnotificationinfo['image'].toString()
//                 : '',
//             pushnotificationinfo['isrecieved'].toString(),
//             pushnotificationinfo['isread'].toString(),
//             pushnotificationinfo['isdelete'].toString(),
//           );
//           pushnotification.add(pushnotif);
//         });
//         await showNotification(
//           pushnotificationinfo['tittle'].toString(),
//           pushnotificationinfo['description'].toString(),
//           pushnotificationinfo['notificationid'],
//         );
//         print(pushnotificationinfo['notificationid']);
//       } else {
//         print('Failed to mark notification as received.');
//       }
//     } catch (e) {
//       print('Error while processing notification: $e');
//     }
//   }

//   Future<void> showNotification(
//       String title, String description, int id) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       description,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyBackgroundService(),
//     );
//   }
// }
