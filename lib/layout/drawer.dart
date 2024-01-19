import 'dart:convert';

import 'package:eportal/layout/home.dart';
import 'package:eportal/layout/profile.dart';
import 'package:flutter/material.dart';
import 'package:eportal/main.dart';
import 'package:eportal/layout/cashadvance.dart';
import 'package:eportal/layout/requestleave.dart';
import 'package:eportal/layout/notification.dart';
import 'package:eportal/layout/coop.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';

void main() {
  runApp(DrawerApp());
}

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawerPage(),
    );
  }
}

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String fullname = '';
  String employeeid = '';
  String image = '';
  int department = 0;
  String departmentname = '';
  String position = '';

  Helper helper = Helper();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo =
        await helper.readJsonToFile('metadata.json');
    UserInfoModel user = UserInfoModel(
        userinfo['image'],
        userinfo['employeeid'],
        userinfo['fullname'],
        userinfo['accesstype'],
        userinfo['department'],
        userinfo['departmentname'],
        userinfo['position']);

    setState(() {
      fullname = user.fullname;
      employeeid = user.employeeid;
      image = user.image;
      department = user.department;
      departmentname = user.departmentname;
      position = user.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '5L SOLUTIONS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(
            255, 215, 36, 24), // Set the app bar color to red
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 215, 36, 24), // Set the sidebar header color to red
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Image.memory(
                      base64Decode(image),
                      fit: BoxFit.cover,
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '$fullname ($employeeid)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$departmentname',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(employeeid: employeeid,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: const Text('Leaves'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestLeave(
                            employeeid: employeeid,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Cash Advance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestCash(
                            employeeid: employeeid,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: const Text('Coop'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Coop()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notification_add),
              title: const Text('Notications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications(employeeid: employeeid,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to log out?"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: Text("Logout"),
                          onPressed: () {
                            // Perform logout and navigate to LoginPage
                            Navigator.pushReplacementNamed(context, '/logout');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            // Add more list items as needed
          ],
        ),
      ),
      body: Center(
        child: HomePage(employeeid: employeeid, department: department),
      ),
    );
  }
}
