import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/notification.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  final String employeeid;

  const Notifications({super.key, required this.employeeid});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
    String _formatDate(String? date) {
    print(date);
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
  String createby = '';

  int _currentIndex = 0;

  Helper helper = Helper();

  List<OffensesModel> offenses = [];

  @override
  void initState() {
    _getoffenses();
    super.initState();
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
        });
      }
      print(offenses[0].employeeid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5L SOLUTION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 215, 36, 24),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
    return ListView(
      children: [
        _buildDismissibleListTile(
          key: UniqueKey(),
          title: 'Christmas & Year End Party',
          subtitle: 'Christmas & Year End Party @ Pacita Astrodom',
          trailing: 'Dec 16',
        ),
        // Add more notification items as needed
      ],
    );
  }

  Widget _buildAnnouncementList() {
    return ListView(
      children: [
        _buildDismissibleListTile(
          key: UniqueKey(),
          title: 'Christmas & Year End Party',
          subtitle: 'Christmas & Year End Party @ Pacita Astrodom',
          trailing: 'Dec 16',
        ),
        // Add more notification items as needed
      ],
    );
  }

  Widget _buildOffensesList({required String employeeid}) {
    return ListView.builder(
      itemCount: offenses.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildDismissibleListTile(
          key: UniqueKey(),
          title: offenses[index].actionid,
          subtitle: offenses[index].violation,
          trailing: offenses[index].date,
        );
      },
    );
  }

  // ... other methods

  Widget _buildDismissibleListTile({
    required Key key,
    required String title,
    required String subtitle,
    required String trailing,
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
        print('Item dismissed: $title');
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
              ),
            ),
            subtitle: Text(subtitle),
            trailing: Text(
              trailing,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
            contentPadding: EdgeInsets.all(9.0),
          ),
        ),
      ),
    );
  }
}
