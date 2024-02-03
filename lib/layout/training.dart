import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/profile.dart';
import 'package:eportal/model/internet_checker.dart';
import 'package:intl/intl.dart';

class Traininginfo extends StatefulWidget {
  final String employeeid;

  const Traininginfo({super.key, required this.employeeid});

  @override
  _TraininginfoStatefulWidgetState createState() =>
      _TraininginfoStatefulWidgetState();
}

class _TraininginfoStatefulWidgetState extends State<Traininginfo> {
  String employeeid = '';
  String training = '';
  String name = '';
  String startdate = '';
  String enddate = '';
  String location = '';

  Helper helper = Helper();

  List<ProfileTraininginfo> traininginfos = [];
    String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.yMMMd('en_US').format(dateTime);
  }

  @override
  void initState() {
    _gettraininginfo();
    super.initState();
  }

Future<void> _gettraininginfo() async {
  final response = await Profileinfo().gettraininginfo(widget.employeeid);
  if (helper.getStatusString(APIStatus.success) == response.message) {
    final jsonData = response.result as List<dynamic>; // Ensure response.result is a list
    for (var trainingData in jsonData) {
      setState(() {
        ProfileTraininginfo traininginfo = ProfileTraininginfo(
          trainingData['employeeid'].toString(), // Convert to string
          trainingData['trainingid'].toString(), // Convert to string
          trainingData['name'].toString(), // Convert to string
          _formatDate(trainingData['startdate'].toString()), // Convert to string
          _formatDate(trainingData['enddate'].toString()), // Convert to string
          trainingData['location'].toString(), // Convert to string
        );
        traininginfos.add(traininginfo);
      });
    }
    print(traininginfos[0].employeeid);
  }
}


  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Trainings',
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: traininginfos.isEmpty
                  ? Center(
                      child: Text(
                        'No training attended.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: traininginfos.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${traininginfos[index].name}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 8.0), // Adjust as needed
                                child: Text(
                                  '${traininginfos[index].startdate} to ${traininginfos[index].enddate}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ));
  }

  void main() {
    runApp(MaterialApp(
      home: Traininginfo(
        employeeid: employeeid,
      ),
    ));
  }
}
