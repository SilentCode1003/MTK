import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/profile.dart';
import 'package:eportal/component/internet_checker.dart';

class Basicinformation extends StatefulWidget {
  final String employeeid;

  const Basicinformation({super.key, required this.employeeid});

  @override
  _BasicinfoStatefulWidgetState createState() =>
      _BasicinfoStatefulWidgetState();
}

class _BasicinfoStatefulWidgetState extends State<Basicinformation> {
  String employeeid = '';
  String firstname = '';
  String lastname = '';
  String middlename = '';
  String gender = '';
  String civilstatus = '';
  String address = '';
  String birthday = '';
  String phone = '';
  String email = '';
  String ercontactname = '';
  String ercontactphone = '';

  Helper helper = Helper();

  List<Basicinfo> profilebasicinfos = [];

  @override
  void initState() {
    super.initState();
    employeeid = widget.employeeid;
    _getBasicInfo();
  }

  Future<void> _getBasicInfo() async {
    final response = await Profileinfo().getbasicinfo(employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var basicinfos in json.decode(jsondata)) {
        setState(() {
          Basicinfo basicinfo = Basicinfo(
            basicinfos['employeeid'],
            basicinfos['firstname'],
            basicinfos['lastname'],
            basicinfos['middlename'],
            basicinfos['gender'],
            basicinfos['civilstatus'],
            basicinfos['address'],
            basicinfos['birthday'],
            basicinfos['phone'],
            basicinfos['email'],
            basicinfos['ercontactname'],
            basicinfos['ercontactphone'],
          );
          employeeid = basicinfo.employeeid;
          firstname = basicinfo.firstname;
          lastname = basicinfo.lastname;
          middlename = basicinfo.middlename;
          gender = basicinfo.gender;
          civilstatus = basicinfo.civilstatus;
          address = basicinfo.address;
          birthday = basicinfo.birthday;
          phone = basicinfo.phone;
          email = basicinfo.email;
          ercontactname = basicinfo.ercontactname;
          ercontactphone = basicinfo.ercontactphone;
        });
      }
      print(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Employee ID',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    employeeid,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Last Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    lastname,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'First Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    firstname,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Middle Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    middlename,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Gender',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    gender,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Civil Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    civilstatus,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Address',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Birthday',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    birthday,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                  child: Text(
                    phone,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    email,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Emergency Contact Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    ercontactname,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Emergency Contact Phone',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    ercontactphone,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: Basicinformation(
        employeeid: employeeid,
      ),
    ));
  }
}
