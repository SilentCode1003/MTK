import 'package:flutter/material.dart';
import 'package:eportal/layout/attendance.dart';
import 'package:eportal/layout/index.dart';
import 'package:eportal/layout/salary.dart';

// void main() {
//   runApp(const Homepage());
// }

class Homepage extends StatelessWidget {
  final String employeeid;
  final int department;
  const Homepage({Key? key, required this.employeeid, required this.department})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        employeeid: employeeid,
        department: department,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String employeeid;
  final int department;
  const MyHomePage(
      {Key? key, required this.employeeid, required this.department})
      : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

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
    switch (index) {
      case 0:
        return Index(
          employeeid: widget.employeeid,
          department: widget.department,
        );
      case 1:
        return Attendance();
      case 2:
        return Salary();
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

  MyBottomNavBar({
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
