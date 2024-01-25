import 'package:flutter/material.dart';
import 'package:eportal/layout/attendance.dart';
import 'package:eportal/layout/index.dart';
import 'package:eportal/layout/salary.dart';

import '../model/userinfo.dart';
import '../repository/helper.dart';

class HomePage extends StatefulWidget {
  final String employeeid;
  final int department;

  const HomePage({Key? key, required this.employeeid, required this.department})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
   String fullname = '';
  String employeeid = '';
  String image = '';

  Helper helper = Helper();

  
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

    Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo =
        await helper.readJsonToFile('assets/metadata.json');
    UserInfoModel user = UserInfoModel(userinfo['image'],
        userinfo['employeeid'], userinfo['fullname'], userinfo['accesstype'], userinfo['department'], userinfo['departmentname'], userinfo['position'], userinfo['jobstatus'],);



    setState(() {
      fullname = user.fullname;
      employeeid = user.employeeid;
      image = user.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        activeColor: Colors.red, // Set active color to red
      ),
    );
  }

  Widget _getBody(int index) {
    print(widget.employeeid);
    switch (index) {
      case 0:
        return Index(
          employeeid: widget.employeeid,
          department: widget.department,
        );
      case 1:
        return Attendance(
          employeeid: widget.employeeid,
        );
      case 2:
        return const Salary();
      default:
        return Container();
    }
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color activeColor;

  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Attendance',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Payslip',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: activeColor, // Set active color to red
    );
  }
}
