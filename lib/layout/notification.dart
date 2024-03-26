import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/notification.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:eportal/layout/announcementdetails.dart';
import 'package:eportal/component/developer_options_checker.dart';

class Notifications extends StatefulWidget {
  final String employeeid;

  const Notifications({Key? key, required this.employeeid}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _formatDate(String? date) {
    if (date == "" || date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMM dd', 'en_US').format(dateTime);
  }

  int _currentIndex = 0;

  Helper helper = Helper();
  List<AllNotifications> notification = [];
  List<PushNotifcations> pushnotification = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    initializeNotifications();
    _getnotification();
    _Pushnotification();
    super.initState();
    _checkDeveloperOptions();
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _Pushnotification() async {
    final response =
        await UserNotifications().getnotification(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      int notificationId = 0;
      for (var pushnotificationinfo in json.decode(jsondata)) {
        if (pushnotificationinfo['isrecieved'].toString() == 'NO') {
          setState(() {
            PushNotifcations pushnotif = PushNotifcations(
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
            pushnotification.add(pushnotif);
          });
          await showNotification(
            pushnotificationinfo['tittle'].toString(),
            pushnotificationinfo['description'].toString(),
            pushnotificationinfo['notificationid'],
          );
          print(pushnotificationinfo['notificationid']);
          await _recievednotification(
              pushnotificationinfo['notificationid'].toString());
        }
      }
    }
  }

  Future<void> showNotification(
      String title, String description, int id) async {
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

  Future<void> _recievednotification(String notificationid) async {
    try {
      final response =
          await UserNotifications().recievednotication(notificationid);
      if (response.status == 200) {
        print('success $notificationid');
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error $notificationid');
    }
  }

  Future<void> _readnotification(String notificationid) async {
    try {
      final response = await UserNotifications().readnotication(notificationid);
      if (response.status == 200) {
        print('success $notificationid');
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error $notificationid');
    }
  }

  Future<void> _getnotification() async {
    final response =
        await UserNotifications().getnotification(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var notificationinfo in json.decode(jsondata)) {
        setState(() {
          AllNotifications notif = AllNotifications(
            notificationinfo['notificationid'].toString(),
            notificationinfo['employeeid'].toString(),
            _formatDate(notificationinfo['date'].toString()),
            notificationinfo['tittle'].toString(),
            notificationinfo['description'],
            notificationinfo['subdescription'] ?? '',
            notificationinfo['image'] != null
                ? notificationinfo['image'].toString()
                : '',
            notificationinfo['isrecieved'].toString(),
            notificationinfo['isread'].toString(),
            notificationinfo['isdelete'].toString(),
          );
          notification.add(notif);
        });
      }
    }
  }

  Future<void> _reloadnotification() async {
    try {
      final response =
          await UserNotifications().reloadnotification(widget.employeeid);
      if (response.status == 200) {
        print('success');
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error');
    }
  }

  Future<void> _deletenotification(String notificationid) async {
    try {
      final response =
          await UserNotifications().deletenotication(notificationid);
      if (response.status == 200) {
        print('success');
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5L SOLUTION',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 215, 36, 24)),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawerPage()),
                );
              },
            ),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildNotificationList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _reloadnotification();
          notification.clear();
          _getnotification();
        });
      },
      child: notification.isEmpty
          ? Center(
              child: Text("No Announcement found."),
            )
          : ListView.builder(
              itemCount: notification.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(notification[index].notificationid),
                  onDismissed: (direction) {
                    setState(() {
                      notification.removeAt(index);
                      _deletenotification(notification[index].notificationid);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Item dismissed"),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Stack(
                    children: [
                      _buildListTile(
                        title: notification[index].tittle,
                        subtitle: notification[index].description,
                        trailing: notification[index].date,
                        isRead: notification[index].isread,
                        notificationid: notification[index].notificationid,
                        onTap: () {
                          _readnotification(notification[index].notificationid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllDetailsPage(
                                employeeid: widget.employeeid,
                                notificationId:
                                    notification[index].notificationid,
                                title: notification[index].tittle,
                                description: notification[index].description,
                                targetDate: notification[index].date,
                                image: notification[index].image,
                                type: notification[index].tittle,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 15,
                        right: 10,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: notification[index].isread.toLowerCase() ==
                                    'yes'
                                ? Colors.white
                                : const Color.fromARGB(255, 206, 14, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

Widget _buildListTile({
  required String title,
  required String subtitle,
  required String trailing,
  required String isRead,
  required String notificationid,
  VoidCallback? onTap,
}) {
  final bool read = isRead.toLowerCase() == 'yes';
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        fontWeight: read ? FontWeight.normal : FontWeight.bold,
        fontSize: 20.0,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(
        fontWeight: read ? FontWeight.normal : FontWeight.bold,
        fontSize: 16.0,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    trailing: Text(
      trailing,
      style: TextStyle(
        fontWeight: read ? FontWeight.normal : FontWeight.bold,
        fontSize: 14.0,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    contentPadding: const EdgeInsets.all(9.0),
    onTap: () {
      print('Notification ID: $notificationid');
      if (onTap != null) {
        onTap();
      }
    },
  );
}
