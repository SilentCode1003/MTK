import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/profile.dart';
import 'package:eportal/model/internet_checker.dart';


class Workinfo extends StatefulWidget {
  final String employeeid;

  const Workinfo({super.key, required this.employeeid});

  @override
  _WorkinfoStatefulWidgetState createState() =>
      _WorkinfoStatefulWidgetState();
}

class _WorkinfoStatefulWidgetState extends State<Workinfo> {
  String employeeid = '';
  String departmentid = '';
  String position = ''; 
  String departmenthead = '';
  String jobstatus = '';
  String hiredate = '';
  String tenure = '';

    Helper helper = Helper();

  List<ProfileWorkinfo> workinfos = [];

  @override
  void initState() {
    super.initState();
    employeeid = widget.employeeid;
    _getWorkInfo();
  }

Future<void> _getWorkInfo() async {
  final response = await Profileinfo().getworkinfo(employeeid);
  if (helper.getStatusString(APIStatus.success) == response.message) {
    final jsonData = response.result as List<dynamic>; // Ensure response.result is a list
    for (var basicInfos in jsonData) {
      setState(() {
        ProfileWorkinfo basicInfo = ProfileWorkinfo(
          basicInfos['employeeid'].toString(), 
          basicInfos['department'].toString(),
          basicInfos['position'].toString(),
          basicInfos['departmenthead'].toString(),
          basicInfos['jobstatus'].toString(),
          basicInfos['hiredate'].toString(),
          basicInfos['tenure'].toString(),
        );
        employeeid = basicInfo.employeeid;
        departmentid = basicInfo.departmentid;
        position = basicInfo.position;
        departmenthead = basicInfo.departmenthead;
        jobstatus = basicInfo.jobstatus;
        hiredate = basicInfo.hiredate;
        tenure = basicInfo.tenure;
      });
    }
    print(employeeid);
  }
}



  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work Information',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(employeeid: employeeid,)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Department',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$departmentid',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Position',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$position',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Job Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$jobstatus',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Head Department',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$departmenthead',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hire Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$hiredate',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tenure',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$tenure',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
  void main() {
  runApp(MaterialApp(
    home: Workinfo(employeeid: employeeid,),
  ));
}

}

