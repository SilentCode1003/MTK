import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/layout/basicinfo.dart';
import 'package:eportal/layout/workinfo.dart';
import 'package:eportal/layout/govinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eportal/layout/changepass.dart';

class Profile extends StatefulWidget {
  final String employeeid;

  const Profile({super.key, required this.employeeid});

  @override
  _ProfileStatefulWidgetState createState() => _ProfileStatefulWidgetState();
}

class _ProfileStatefulWidgetState extends State<Profile> {
  String fullname = '';
  String employeeid = '';
  String image = '';
  int department = 0;
  String departmentname = '';
  String position = '';
  bool isLoading = true; // Add this line

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
      userinfo['position'],
    );

    setState(() {
      fullname = user.fullname;
      employeeid = user.employeeid;
      image = user.image;
      department = user.department;
      departmentname = user.departmentname;
      position = user.position;
      isLoading = false; // Set loading to false when data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
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
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (isLoading) ShimmerLoading(), // Show shimmer when loading
          if (!isLoading) ...[
            // Profile Picture
            Positioned(
              top: 20.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80.0),
                child: Image.memory(
                  base64Decode(image),
                  fit: BoxFit.cover,
                  width: 130.0,
                  height: 130.0,
                ),
              ),
            ),
            // Name Text
            Positioned(
              top: 160.0,
              child: Text(
                '$fullname', // Replace with the actual name
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 190.0,
              child: Text(
                '$position', // Replace with the actual name
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
            ),
            Positioned(
              top: 210.0,
              child: Text(
                '$departmentname', // Replace with the actual name
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
            ),
            Positioned(
              top: 250.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Basicinformation(employeeid: employeeid,)),
                  );
                },
                child: Container(
                  height: 50,
                  width: 325,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 242, 242),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Icon of a person
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      // Text for basic information
                      Text(
                        'Basic Information',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      // Greater-than icon with margin on the right side
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 310.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Workinfo(employeeid: employeeid,)),
                  );
                },
                child: Container(
                  height: 50,
                  width: 325,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 242, 242),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Icon of a person
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.work,
                          color: Colors.black,
                        ),
                      ),
                      // Text for basic information
                      Text(
                        'Work Information',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      // Greater-than icon with margin on the right side
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 370.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Govinfo(employeeid: employeeid,)),
                  );
                },
                child: Container(
                  height: 50,
                  width: 325,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 242, 242),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Icon of a person
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.description,
                          color: Colors.black,
                        ),
                      ),
                      // Text for basic information
                      Text(
                        'Goverment Information',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      // Greater-than icon with margin on the right side
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 430.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  );
                },
                child: Container(
                  height: 50,
                  width: 325,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 242, 242),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Icon of a person
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                      // Text for basic information
                      Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      // Greater-than icon with margin on the right side
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: Profile(
        employeeid: employeeid,
      ),
    ));
  }
}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 20),
            Container(
              width: 120,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: 80,
              height: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
