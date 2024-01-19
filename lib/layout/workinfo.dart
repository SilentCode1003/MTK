import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/profile.dart';


class Workinfo extends StatefulWidget {
  final String employeeid;

  const Workinfo({super.key, required this.employeeid});

  @override
  _WorkinfoStatefulWidgetState createState() =>
      _WorkinfoStatefulWidgetState();
}

class _WorkinfoStatefulWidgetState extends State<Workinfo> {
  String employeeid = '';
  String department = '';
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
      final jsondata = json.encode(response.result);
      for (var basicinfos in json.decode(jsondata)) {
        setState(() {
          // Update the state variables with fetched data
          ProfileWorkinfo basicinfo = ProfileWorkinfo(
            basicinfos['employeeid'],
            basicinfos['department'],
            basicinfos['position'],
            basicinfos['departmenthead'],
            basicinfos['jobstatus'],
            basicinfos['hiredate'],
            basicinfos['tenure'],
          );
          employeeid = basicinfo.employeeid;
          department = basicinfo.department;
          position = basicinfo.position;
          departmenthead = basicinfo.departmenthead;
          jobstatus = basicinfo.jobstatus;
          hiredate = basicinfo.hiredate;
          tenure = basicinfo.tenure;

        });
      }
      print(employeeid);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work Information',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 215, 36, 24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  '$department',
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

