import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/profile.dart';

class Govinfo extends StatefulWidget {
  final String employeeid;

  const Govinfo({super.key, required this.employeeid});

  @override
  _GovinfoStatefulWidgetState createState() => _GovinfoStatefulWidgetState();
}

class _GovinfoStatefulWidgetState extends State<Govinfo> {
  String employeeid = '';
  String idtype = '';
  String idnumber = '';

  Helper helper = Helper();

  List<ProfileGovinfo> govinfos = [];

  @override
  void initState() {
    _getgovinfo();
    super.initState();
  }

  Future<void> _getgovinfo() async {
    final response = await Profileinfo().getgovinfo(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var govinfoid in json.decode(jsondata)) {
        setState(() {
          ProfileGovinfo govinfo = ProfileGovinfo(govinfoid['employeeid'],
              govinfoid['idtype'], govinfoid['idnumber']);
          govinfos.add(govinfo);
        });
      }
      print(govinfos[0].employeeid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Goverment Information',
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
            child: govinfos.isEmpty
                ? Center(
                    child: Text(
                      'No government information available.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: govinfos.length,
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
                                '${govinfos[index].idtype}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0), // Adjust as needed
                              child: Text(
                                '${govinfos[index].idnumber}',
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
      home: Govinfo(
        employeeid: employeeid,
      ),
    ));
  }
}
