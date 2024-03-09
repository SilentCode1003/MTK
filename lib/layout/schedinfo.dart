import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/profile.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';

class Schedule extends StatefulWidget {
  final String employeeid;

  const Schedule({super.key, required this.employeeid});

  @override
  _ScheduleStatefulWidgetState createState() => _ScheduleStatefulWidgetState();
}

class _ScheduleStatefulWidgetState extends State<Schedule> {
  String employeeid = '';
  String shiftid = '';
  String department = '';
  String monday = '';
  String tuesday = '';
  String wednesday = '';
  String thursday = '';
  String friday = '';
  String saturday = '';
  String sunday = '';
  Helper helper = Helper();

  List<Profileshiftinfo> profileshiftinfos = [];

  @override
  void initState() {
    super.initState();
    employeeid = widget.employeeid;
    _checkDeveloperOptions();
    _getShiftInfo();
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }

  Future<void> _getShiftInfo() async {
    final response = await Profileinfo().getshift(employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var shiftinfos in json.decode(jsondata)) {
        setState(() {
          Profileshiftinfo shiftinfo = Profileshiftinfo(
            shiftinfos['employeeid'].toString(),
            shiftinfos['shiftid'].toString(),
            shiftinfos['department'].toString(),
            shiftinfos['monday'].toString(),
            shiftinfos['tuesday'].toString(),
            shiftinfos['wednesday'].toString(),
            shiftinfos['thursday'].toString(),
            shiftinfos['friday'].toString(),
            shiftinfos['saturday'].toString(),
            shiftinfos['sunday'].toString(),
          );
          employeeid = shiftinfo.employeeid;
          shiftid = shiftinfo.shiftid;
          department = shiftinfo.department;
          monday = shiftinfo.monday;
          tuesday = shiftinfo.tuesday;
          wednesday = shiftinfo.wednesday;
          thursday = shiftinfo.thursday;
          friday = shiftinfo.friday;
          saturday = shiftinfo.saturday;
          sunday = shiftinfo.sunday;
        });
      }
      print(monday);
      print(employeeid);
    }
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
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
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 16.0, left: 40.0,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Schedule Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40.00),
                      child: Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 40.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Working hours',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        '9 Hours per shift',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Sunday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 160),
                                  Text(
                                    '8:00:00 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 150),
                                  Text(
                                    '5:00:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Monday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 160),
                                  Text(
                                    monday.split(' ')[1],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 150),
                                  Text(
                                    monday.split(' ')[3],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Tuesday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 160),
                                  Text(
                                    '8:00:00 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 150),
                                  Text(
                                    '5:00:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Wednesday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 160),
                                  Text(
                                    '8:00:00 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 150),
                                  Text(
                                    '5:00:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Thursday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 160),
                                  Text(
                                    '8:00:00 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 150),
                                  Text(
                                    '5:00:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Friday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 160),
                                  Text(
                                    '8:00:00 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 150),
                                  Text(
                                    '5:00:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Container(
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                        bottom: Radius.circular(15),
                      ),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Center(
                                  child: Text(
                                    'Saturday',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time in:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 160),
                                  Text(
                                    '8:00:00 AM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Time out:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 150),
                                  Text(
                                    '5:00:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
