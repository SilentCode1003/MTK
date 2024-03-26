import 'package:flutter/material.dart';
import 'package:eportal/layout/attendance.dart';
import 'package:eportal/layout/index.dart';
import 'package:eportal/layout/payroll.dart';
import 'package:flutter/widgets.dart';
import '../model/userinfo.dart';
import '../repository/helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eportal/api/login.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/layout/requestleave.dart';
import 'package:eportal/layout/overtime.dart';
import 'package:eportal/layout/cashadvance.dart';
import 'package:eportal/layout/coa.dart';
import 'package:eportal/layout/undertime.dart';
import 'package:eportal/layout/coop.dart';

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
      await Future.delayed(const Duration(seconds: 3));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Center(
              child: Text('No Connection!'),
            ),
            content: const Padding(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() {
          //   _selectedIndex = 4;
          // });
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 15,
                      child: Container(
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close_outlined,
                                  size: 30,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RequestLeave(
                                              employeeid: widget.employeeid)),
                                    );
                                  },
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.red,
                                  mini: false,
                                  heroTag: null,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Leaves",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 65),
                          Column(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    print(widget.employeeid);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => COA(
                                                employeeid:
                                                    widget.employeeid)));
                                  },
                                  child: Icon(
                                    Icons.card_giftcard_rounded,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.red,
                                  mini: false,
                                  heroTag: null,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "COA",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 65),
                          Column(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Overtime(
                                                employeeid:
                                                    widget.employeeid)));
                                  },
                                  child: Icon(
                                    Icons.access_time_outlined,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.red,
                                  mini: false,
                                  heroTag: null,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Overtime",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UnderTime(
                                                employeeid:
                                                    widget.employeeid)));
                                  },
                                  child: Icon(
                                    Icons.access_time_outlined,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.red,
                                  mini: false,
                                  heroTag: null,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Undertime",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 60),
                          Column(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RequestCash(
                                              employeeid: widget.employeeid)),
                                    );
                                  },
                                  child: Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.red,
                                  mini: false,
                                  heroTag: null,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Cash Advance",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 60),
                          Column(
                            children: [
                              SizedBox(
                                width: 65,
                                height: 65,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Coop()),
                                    );
                                  },
                                  child: Icon(
                                    Icons.business_outlined,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.red,
                                  mini: false,
                                  heroTag: null,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "COOP",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.now_widgets_outlined),
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        activeColor: Colors.red,
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
        return Salary(
          employeeid: widget.employeeid,
        );
      case 3:
        return Profile(
          employeeid: widget.employeeid,
        );
      case 4:
        return _buildModalBottomSheet();
      default:
        return Container();
    }
  }

  Widget _buildModalBottomSheet() {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(0.1),
        child: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(top: 65.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Text(
                    'Services',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequestLeave(employeeid: employeeid)),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 120.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 65.0),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.red.withOpacity(0.8),
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Leaves",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  COA(employeeid: employeeid)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 120.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 65.0),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.card_giftcard_rounded,
                                      color: Colors.red.withOpacity(0.8),
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "COA",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Overtime(employeeid: employeeid)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 260.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 65.0),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.access_time_outlined,
                                      color: Colors.red.withOpacity(0.8),
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Overtime",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UnderTime(employeeid: employeeid)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 260.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 65.0),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.access_time_filled_outlined,
                                      color: Colors.red.withOpacity(0.8),
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Undertime",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequestCash(employeeid: employeeid)),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 400.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 65.0),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: Colors.red.withOpacity(0.8),
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Cash Advance",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Coop()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 400.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 65.0),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.business_outlined,
                                      color: Colors.red.withOpacity(0.8),
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "COOP",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                  const Text(
                    'View Payslip',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Enter your password'),
                  const SizedBox(height: 15),
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
                      border: const OutlineInputBorder(),
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
  final Function() onSalaryTap;
  final Color activeColor;

  const MyBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onSalaryTap,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      onTap(0);
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      color: currentIndex == 0 ? activeColor : Colors.black,
                    ),
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: currentIndex == 0 ? activeColor : Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        onTap(1);
                      },
                      icon: Icon(
                        Icons.access_time_outlined,
                        color: currentIndex == 1 ? activeColor : Colors.black,
                      ),
                    ),
                    Text(
                      'Attendance',
                      style: TextStyle(
                        color: currentIndex == 1 ? activeColor : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        onTap(2);
                      },
                      icon: Icon(
                        Icons.attach_money_outlined,
                        color: currentIndex == 2 ? activeColor : Colors.black,
                      ),
                    ),
                    Text(
                      'Payroll',
                      style: TextStyle(
                        color: currentIndex == 2 ? activeColor : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      onTap(3);
                    },
                    icon: Icon(
                      Icons.person_outline_outlined,
                      color: currentIndex == 3 ? activeColor : Colors.black,
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: currentIndex == 3 ? activeColor : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
