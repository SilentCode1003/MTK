import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/api/profile.dart';

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

  List<Basicinfo> basicinfos = [];

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
          // Update the state variables with fetched data
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
      print(employeeid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Basic Information',
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
                      )),
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
                  'Employee ID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$employeeid',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Last Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$lastname',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'First Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$firstname',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Middle Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$middlename',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Gender',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$gender',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Civil Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$civilstatus',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$address',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Birthday',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$birthday',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$phone',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$email',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Emergency Contact Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$ercontactname',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Emergency Contact Phone',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0), // Adjust as needed
                child: Text(
                  '$ercontactphone',
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
      home: Basicinformation(
        employeeid: employeeid,
      ),
    ));
  }
}
