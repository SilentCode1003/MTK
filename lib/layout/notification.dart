import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/notification.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications extends StatefulWidget {
  final String employeeid;

  const Notifications({super.key, required this.employeeid});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _formatDate(String? date) {
    if (date == "" || date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMM dd', 'en_US').format(dateTime);
  }

  String employeeid = '';
  String disciplinaryid = '';
  String offenseid = '';
  String actionid = '';
  String violation = '';
  String date = '';
  String offensecreatedby = '';
  String announcementbulletinid = '';
  String announcementtitle = '';
  String announcementimage = '';
  String announcementtype = '';
  String announcementdescription = '';
  String announcementtargetdate = '';
  String announcementcreatedby = '';

  Set<Key> dismissedAnnouncementKeys = {};
  Set<Key> dismissedOffensesKeys = {};

  int _currentIndex = 0;

  Helper helper = Helper();

  List<OffensesModel> offenses = [];
  List<AnnouncementModel> announcements = [];
  List<AllModel> allnotification = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _initializeLocalNotifications();
    _getoffenses();
    _getannoucement();
    super.initState();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    tz.initializeTimeZones();
  }

  Future<void> _getoffenses() async {
    final response = await UserNotifications().getoffenses(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var offenseinfo in json.decode(jsondata)) {
        setState(() {
          OffensesModel offense = OffensesModel(
            offenseinfo['employeeid'].toString(),
            offenseinfo['disciplinaryid'].toString(),
            offenseinfo['offenseid'].toString(),
            offenseinfo['actionid'].toString(),
            offenseinfo['violation'],
            _formatDate(offenseinfo['date']),
            offenseinfo['createby'].toString(),
          );
          offenses.add(offense);

          AllModel notification = AllModel(
              offenseinfo['actionid'].toString(),
              offenseinfo['violation'].toString());
          allnotification.add(notification);
        });
      }
    }
  }

  Future<void> _getannoucement() async {
    final response =
        await UserNotifications().getannouncement(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var announcementinfo in json.decode(jsondata)) {
        setState(() {
          AnnouncementModel announcement = AnnouncementModel(
            announcementinfo['bulletinid'].toString(),
            announcementinfo['tittle'].toString(),
            announcementinfo['image'].toString(),
            announcementinfo['type'].toString(),
            announcementinfo['description'].toString(),
            _formatDate(announcementinfo['targetdate']),
            announcementinfo['createby'].toString(),
          );
          announcements.add(announcement);
          AllModel notification = AllModel(
              announcementinfo['tittle'].toString(),
              announcementinfo['description'].toString());
          allnotification.add(notification);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5L SOLUTION',
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
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrawerApp()),
                );
              },
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Announcements'),
                Tab(text: 'Offenses'),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildNotificationList(),
              _buildAnnouncementList(),
              _buildOffensesList(
                employeeid: widget.employeeid,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    // return ListView(
    //   children: [
    //     _buildDismissibleListTile(
    //       key: UniqueKey(),
    //       title: 'Christmas & Year End Party',
    //       subtitle: 'Christmas & Year End Party @ Pacita Astrodom',
    //       trailing: 'Dec 16',
    //     ),
    //     // Add more notification items as needed

    //   ],
    // );

    return ListView.builder(
      itemCount: allnotification.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildDismissibleListTile(
          key: Key(allnotification[index].tittle),
          title: allnotification[index].tittle,
          subtitle: allnotification[index].content,
          trailing: allnotification[index].tittle,
          onTap: () {
            _scheduleLocalNotification(
              allnotification[index].tittle,
              allnotification[index].content,
            );
          },
        );
      },
    );
  }

  Widget _buildAnnouncementList() {
    if (announcements.isEmpty) {
      return Center(
        child: Text("No Announcement found."),
      );
    }

    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildDismissibleListTile(
          key: Key(announcements[index].bulletinid),
          title: announcements[index].tittle,
          subtitle: announcements[index].description,
          trailing: announcements[index].targetdate,
          onTap: () {
            _scheduleLocalNotification(
              announcements[index].tittle,
              announcements[index].description,
            );
          },
        );
      },
    );
  }

  Widget _buildOffensesList({required String employeeid}) {
    if (offenses.isEmpty) {
      return Center(
        child: Text("No offenses found."),
      );
    }

    return ListView.builder(
      itemCount: offenses.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildDismissibleListTile(
          key: Key(offenses[index].actionid),
          title: offenses[index].actionid,
          subtitle: offenses[index].violation,
          trailing: offenses[index].date,
        );
      },
    );
  }

  Widget _buildDismissibleListTile({
    required Key key,
    required String title,
    required String subtitle,
    required String trailing,
    VoidCallback? onTap,
  }) {
    return Dismissible(
      key: key,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Handle dismiss action if needed
      },
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, top: 8.0),
        child: Container(
          margin: EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: const Color.fromARGB(255, 215, 36, 24),
                width: 5.0,
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
            trailing: Text(
              trailing,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
            contentPadding: EdgeInsets.all(9.0),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  Future<void> _scheduleLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '123', // Replace with your own channel ID
      'HRMIS', // Replace with your own channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    int notificationId = DateTime.now().millisecondsSinceEpoch ~/
        1000; // Unique ID based on current time
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: 'notification_payload', // Add a payload if needed
    );
  }
}
