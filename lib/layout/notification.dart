import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';

void main() {
  runApp(const Notifications());
}

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
            bottom: const TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Announcements'),
                Tab(text: 'Offenses'),
                Tab(text: 'Leaves'),
                Tab(text: 'Cash Advance'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildNotificationList(),
              _buildAnnouncementList(),
              _buildOffensesList(),
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
    // Implement the list of announcements
    return Container();
  }

  Widget _buildOffensesList() {
    // Implement the list of offenses
    return Container();
  }

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
