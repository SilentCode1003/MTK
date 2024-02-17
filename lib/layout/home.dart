import 'package:flutter/material.dart';
import 'package:eportal/layout/attendance.dart';
import 'package:eportal/layout/index.dart';
import 'package:eportal/layout/salary.dart';
import '../model/userinfo.dart';
import '../repository/helper.dart';

class HomePage extends StatefulWidget {
  final String employeeid;
  final int departmentid;

  const HomePage(
      {Key? key, required this.employeeid, required this.departmentid})
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
  bool _isPasswordObscured = true;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo =
        await helper.readJsonToFile('assets/metadata.json');
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
        onSalaryTap: _showLoginDialog, // New line
      ),
    );
  }

  Widget _getBody(int index) {
    print(widget.employeeid);
    switch (index) {
      case 0:
        return Index(
          employeeid: widget.employeeid,
          departmentid: widget.departmentid,
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

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _showLoginDialog() {
    TextEditingController passwordController =
        TextEditingController(); // New line
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Login')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Please login to view Salary.'),
              TextField(
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _togglePasswordVisibility();
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('LOGIN'),
              onPressed: () {
                const Salary();
              },
            ),
          ],
        );
      },
    );
  }
}

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Function() onSalaryTap; // New line
  final Color activeColor;

  const MyBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onSalaryTap, // New line
    required this.activeColor,
  }) : super(key: key);

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
      onTap: (index) {
        if (index == 2) {
          // If Salary tab is tapped, show login dialog
          onSalaryTap();
        } else {
          onTap(index);
        }
      },
      selectedItemColor: activeColor, // Set active color to red
    );
  }
}
