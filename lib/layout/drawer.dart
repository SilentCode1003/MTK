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
  String jobstatus = '';
  Map<String, dynamic> userinfo = {};

  Helper helper = Helper();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  Future<void> _getUserInfo() async {
    userinfo = await helper.readJsonToFile('metadata.json');
    UserInfoModel user = UserInfoModel(
      userinfo['image'],
      userinfo['employeeid'],
      userinfo['fullname'],
      userinfo['accesstype'],
      userinfo['department'],
      userinfo['departmentname'],
      userinfo['position'],
      userinfo['jobstatus'],
    );

    setState(() {
      fullname = user.fullname;
      employeeid = user.employeeid;
      image = user.image;
      department = user.department;
      departmentname = user.departmentname;
      position = user.position;
      jobstatus = user.jobstatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '5L Solutions Supply & Allied Services Corp.',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0), // Adjust the value as needed
            child: IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.black,
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
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 252, 252, 252),
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
                    '$fullname',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$departmentname',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (userinfo['jobstatus'] == 'apprentice')
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
              ),
            if (userinfo['jobstatus'] == 'apprentice')
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Logout"),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/logout');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            if (userinfo['jobstatus'] == 'regular' || userinfo['jobstatus'] == 'probitionary')
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
              ),
            if (userinfo['jobstatus'] == 'regular' || userinfo['jobstatus'] == 'probitionary')
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: const Text('Leaves'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestLeave(
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
              ),
            if (userinfo['jobstatus'] == 'regular')
              ListTile(
                leading: Icon(Icons.attach_money),
                title: const Text('Cash Advance'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestCash(
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
              ),
            if (userinfo['jobstatus'] == 'regular')
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
            if (userinfo['jobstatus'] == 'regular' || userinfo['jobstatus'] == 'probitionary')
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Logout"),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/logout');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
      body: Center(
        child: HomePage(employeeid: employeeid, department: department),
      ),
    );
  }
}
