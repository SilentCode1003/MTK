import 'dart:convert';
import 'package:eportal/layout/home.dart';
import 'package:eportal/layout/profile.dart';
import 'package:flutter/material.dart';
import 'package:eportal/layout/cashadvance.dart';
import 'package:eportal/layout/requestleave.dart';
import 'package:eportal/layout/notification.dart';
import 'package:eportal/layout/coop.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/layout/overtime.dart';
import 'package:eportal/layout/request.dart';

void main() {
  runApp(DrawerApp());
}

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: const DrawerPage(),
    );
  }
}

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String fullname = '';
  String employeeid = '';
  String image = '';
  int departmentid = 0;
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
      userinfo['departmentid'],
      userinfo['departmentname'],
      userinfo['position'],
      userinfo['jobstatus'],
    );

    setState(() {
      fullname = user.fullname;
      employeeid = user.employeeid;
      image = user.image;
      departmentid = user.departmentid;
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications),
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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '$departmentname',
                      style: const TextStyle(
                        color: Colors.black,
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
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          employeeid: employeeid,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy),
                  title: const Text('Request'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Request(
                           employeeid: employeeid,
                          jobstatus: jobstatus,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Coop'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Coop()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.mobile_friendly),
                  title: const Text('Devices'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Coop()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: const Center(
                            child: Text('Are you sure you want to log out?', style: TextStyle(fontSize: 15),),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0),
                          ),
                          actions: [
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              height: 40,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/logout');
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
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
      ),
       body: HomePage(employeeid: employeeid, departmentid: departmentid),
    );
  }
}
