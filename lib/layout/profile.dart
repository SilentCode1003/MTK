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
import 'package:eportal/layout/schedinfo.dart';
import 'package:eportal/layout/training.dart';
import 'package:eportal/component/developer_options_checker.dart';

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
  int departmentid = 0;
  String departmentname = '';
  String position = '';
  bool isLoading = true; // Add this line

  Helper helper = Helper();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    _checkDeveloperOptions();
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }

  Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo =
    await helper.readJsonToFile('metadata.json');
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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0, // Set elevation to 0 to remove the shadow
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
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (isLoading) const ShimmerLoading(),
            if (!isLoading) ...[
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
                  fullname,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 190.0,
                child: Text(
                  position,
                  style:
                      const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                ),
              ),
              Positioned(
                top: 210.0,
                child: Text(
                  departmentname,
                  style:
                      const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                ),
              ),
              Positioned(
                top: 250.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Basicinformation(
                                employeeid: employeeid,
                              )),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Basic Information',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
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
                      MaterialPageRoute(
                          builder: (context) => Workinfo(
                                employeeid: employeeid,
                              )),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            Icons.work,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Work Information',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
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
                      MaterialPageRoute(
                          builder: (context) => Schedule(
                                employeeid: employeeid,
                              )),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Work Scheduled',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
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
                      MaterialPageRoute(
                          builder: (context) => Govinfo(
                                employeeid: employeeid,
                              )),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            Icons.description,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Goverment Information',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
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
                top: 490.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Traininginfo(
                                employeeid: employeeid,
                              )),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            Icons.assignment,
                            color: Colors.black,
                          ),
                        ),
                        // Text for basic information
                        Text(
                          'Trainings',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        // Greater-than icon with margin on the right side
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
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
                top: 550.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(
                                employeeid: employeeid,
                              )),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 242, 242),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        // Icon of a person
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
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
                          padding: EdgeInsets.only(right: 10),
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
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
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
