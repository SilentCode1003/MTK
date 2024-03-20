import 'package:flutter/material.dart';

class Newhome extends StatefulWidget {
  const Newhome({super.key});

  @override
  State<Newhome> createState() => _NewhomeState();
}

class _NewhomeState extends State<Newhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          mini: true,
          heroTag: "customTag",
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    "Attendance",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.attach_money_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    "Payroll",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
