import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:eportal/api/notification.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Helper helper = Helper();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String _formatDate(String? date) {
  if (date == "" || date == null) return '';
  DateTime dateTime = DateTime.parse(date);
  return DateFormat('MMM dd', 'en_US').format(dateTime);
}

Future<void> pushNotificationHandler(
    String employeeId,
    List<PushNotifcations> pushNotifications,
    Function(String, String, int) showNotification,
    Function(String) receivedNotification) async {
  final response = await UserNotifications().getnotification(employeeId);
  if (helper.getStatusString(APIStatus.success) == response.message) {
    final jsondata = json.encode(response.result);
    for (var pushnotificationinfo in json.decode(jsondata)) {
      if (pushnotificationinfo['isrecieved'].toString() == 'NO') {
        PushNotifcations pushNotif = PushNotifcations(
          pushnotificationinfo['notificationid'].toString(),
          pushnotificationinfo['employeeid'].toString(),
          _formatDate(pushnotificationinfo['date'].toString()),
          pushnotificationinfo['tittle'].toString(),
          pushnotificationinfo['description'],
          pushnotificationinfo['subdescription'] ?? '',
          pushnotificationinfo['image'] != null
              ? pushnotificationinfo['image'].toString()
              : '',
          pushnotificationinfo['isrecieved'].toString(),
          pushnotificationinfo['isread'].toString(),
          pushnotificationinfo['isdelete'].toString(),
        );
        pushNotifications.add(pushNotif);
        await showNotification(
          pushnotificationinfo['tittle'].toString(),
          pushnotificationinfo['description'].toString(),
          pushnotificationinfo['notificationid'],
        );
        await receivedNotification(
            pushnotificationinfo['notificationid'].toString());
      }
    }
  }
}

Future<void> showNotification(String title, String description, int id) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    description,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

Future<void> receivedNotification(String notificationId) async {
  try {
    final response =
        await UserNotifications().recievednotication(notificationId);
    if (response.status == 200) {
      print('success $notificationId');
    } else {
      print('hindi success');
    }
  } catch (e) {
    print('error $notificationId');
  }
}

Future<void> reloadNotification(String employeeId) async {
  try {
    final response = await UserNotifications().reloadnotification(employeeId);
    if (response.status == 200) {
      print('success');
    } else {
      print('hindi success');
    }
  } catch (e) {
    print('error');
  }
}
