import 'package:flutter/material.dart';
import 'package:eportal/layout/attendance.dart';
import 'package:eportal/layout/index.dart';
import 'package:eportal/layout/salary.dart';
import '../model/userinfo.dart';
import '../repository/helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eportal/api/login.dart';

class HomePage extends StatefulWidget {
  final String employeeid;
  final int departmentid;

  const HomePage({
    Key? key,
    required this.employeeid,
    required this.departmentid,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String fullname = '';
  String employeeid = '';
  String image = '';
  Helper helper = Helper();
  bool isLoading = false;
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  Future<void> _paysliplogin(String employeeid, String password) async {
    setState(() {
      isLoading = true;
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await Future.delayed(Duration(seconds: 3));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Center(
              child: Text('No Connection!'),
            ),
            content: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                'Please check your internet connection and try again.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: 250,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 30.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final response = await Login().paysliplogin(employeeid, password);
      print(employeeid);
      print(password);

      if (response.status == 200) {
        setState(() {
          _selectedIndex = 2;
        });
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Access'),
            content: const Text('Incorrect password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to connect to the server. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
        onSalaryTap: _showLoginDialog,
      ),
    );
  }

  Widget _getBody(int index) {
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

  bool _isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isPasswordFieldEmpty = passwordController.text.isEmpty;
            bool isLoginDisabled = isPasswordFieldEmpty;

            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'View Payslip',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Enter your password'),
                  SizedBox(height: 15),
                  TextField(
                    obscureText: _isPasswordObscured,
                    controller: passwordController,
                    onChanged: (value) {
                      setState(() {
                        isPasswordFieldEmpty = value.isEmpty;
                        isLoginDisabled = isPasswordFieldEmpty;
                      });
                    },
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
                SizedBox(
                  width: 120,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      passwordController.clear();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: 130,
                  height: 40,
                  child: TextButton(
                    onPressed: isLoginDisabled
                        ? null
                        : () {
                            _paysliplogin(
                                widget.employeeid, passwordController.text);
                            passwordController.clear();
                            Navigator.of(context).pop();
                          },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          isLoginDisabled ? Colors.grey : Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
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
