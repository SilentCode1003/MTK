import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/profile.dart';
import 'package:eportal/model/internet_checker.dart';

class Schedule extends StatefulWidget {
  final String employeeid;

  const Schedule({super.key, required this.employeeid});

  @override
  _ScheduleStatefulWidgetState createState() => _ScheduleStatefulWidgetState();
}

class _ScheduleStatefulWidgetState extends State<Schedule> {
  String employeeid = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work Schedule',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Positioned(
          top: 250.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0), // Adjust horizontal padding as needed
            child: Container(
              height: 85,
              width: MediaQuery.of(context).size.width - 32, // Adjust the padding and subtract it from the screen width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 5,
                    ),
                    child: Text(
                      'Sunday',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 7,
                        ),
                        child: Text(
                          'Shift',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 7,
                          right: 20,
                        ),
                        child: Text(
                          '8:00 AM - 5:00 PM',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 7,
                        ),
                        child: Text(
                          'Break',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 7,
                          right: 20,
                        ),
                        child: Text(
                          '12:00 PM - 1:00 PM',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: Schedule(
        employeeid: employeeid,
      ),
    ));
  }
}
