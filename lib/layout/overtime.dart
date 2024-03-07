import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/api/overtime.dart';
import 'package:eportal/repository/helper.dart';
import 'dart:convert';
import 'package:eportal/model/userinfo.dart';

class Overtime extends StatefulWidget {
  final String employeeid;
  const Overtime({super.key, required this.employeeid});

  @override
  State<Overtime> createState() => _OvertimeState();
}

class _OvertimeState extends State<Overtime> {  
  String approveot_id = '';
  String employeeid = '';
  String attendancedate = '';
  String clockin = '';
  String clockout = '';
  String totalhours = '';
  String payrolldate = '';
  String overtimestatus = '';

  List<OvertimeModel> otinfo = [];
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
  _getCash();
  }

    Future<void> _getCash() async {
    final response = await OverTime().getot(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var overtimeinfo in json.decode(jsondata)) {
        setState(() {
          OvertimeModel userot = OvertimeModel(
              overtimeinfo['approveot_id'].toString(),
              overtimeinfo['employeeid'].toString(),
              overtimeinfo['attendancedate'].toString(),
              overtimeinfo['clockin'].toString(),
              overtimeinfo['clockout'].toString(),
              overtimeinfo['totalhours'].toString(),
              overtimeinfo['payrolldate'].toString(),
              overtimeinfo['overtimestatus'].toString());
          otinfo.add(userot);
        });
      }
      print(otinfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Overtime',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DrawerPage()),
            );
          },
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: <Widget>[
            Expanded(
              child: otinfo.isEmpty
                  ? Center(
                      child: Text(
                        'No Overtime',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: otinfo.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: const Text(
                                            'Cash Details',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '₱ ${otinfo[index].totalhours}',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Start Date:     ${otinfo[index].payrolldate}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'End Date:     ${otinfo[index].payrolldate}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Applied Date: ${otinfo[index].payrolldate}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Reason: ${otinfo[index].totalhours}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Status: ${otinfo[index].overtimestatus}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: otinfo[index].overtimestatus ==
                                                      'Pending'
                                                  ? Colors.orange
                                                  : otinfo[index].overtimestatus ==
                                                          'Approved'
                                                      ? Colors.green
                                                      : otinfo[index]
                                                                  .overtimestatus ==
                                                              'Rejected'
                                                          ? Colors.red
                                                          : otinfo[index]
                                                                      .overtimestatus ==
                                                                  'Cancelled'
                                                              ? Colors.red
                                                              : Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 50),
                                        if (otinfo[index].overtimestatus ==
                                            'Pending')
                                          Center(
                                            // child: ElevatedButton(
                                            //   onPressed: () {
                                            //     _cancelLeaveApplication(
                                            //         userscash[index]
                                            //             .cashadvanceid
                                            //             .toString());
                                            //     Navigator.pop(context);
                                            //   },
                                            //   style: ElevatedButton.styleFrom(
                                            //     primary: Colors.red,
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(20),
                                            //     ),
                                            //     minimumSize: Size(250, 50),
                                            //   ),
                                            //   child: Text(
                                            //     'Cancel Cash Application',
                                            //     style: TextStyle(fontSize: 18),
                                            //   ),
                                            // ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        '${otinfo[index].totalhours} Hours',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 7.0),
                                          Text(
                                            'Time: ${otinfo[index].clockin} - ${otinfo[index].clockout}',
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            'Date: ${otinfo[index].attendancedate}',
                                          )
                                        ],
                                      ),
                                      trailing: Text(
                                        (otinfo[index].overtimestatus),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: otinfo[index].overtimestatus ==
                                                  'Pending'
                                              ? Colors.orange
                                              : otinfo[index].overtimestatus ==
                                                      'Approved'
                                                  ? Colors.green
                                                  : otinfo[index].overtimestatus ==
                                                          'Rejected'
                                                      ? Colors.red
                                                      : otinfo[index]
                                                                  .overtimestatus ==
                                                              'Cancelled'
                                                          ? Colors.red
                                                          : Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
