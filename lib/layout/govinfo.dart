import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/layout/profile.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/profile.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';

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
    _checkDeveloperOptions();
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
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
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Goverment Information',
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
          child: Column(
            children: <Widget>[
              Expanded(
                child: govinfos.isEmpty
                    ? const Center(
                        child: Text(
                          'No government information available.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        itemCount: govinfos.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    govinfos[index].idtype,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0), // Adjust as needed
                                  child: Text(
                                    govinfos[index].idnumber,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          )),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: Govinfo(
        employeeid: employeeid,
      ),
    ));
  }
}
