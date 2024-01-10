import 'dart:convert';

import 'package:eportal/api/leave.dart';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(RequestLeave());
// }

class RequestLeave extends StatefulWidget {
  final String employeeid;

  const RequestLeave({super.key, required this.employeeid});

  @override
  State<RequestLeave> createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.yMMMd('en_US').format(dateTime);
  }

  String leaveid = '';
  String employeeid = '';
  String leavestartdate = '';
  String leaveenddate = '';
  String leavetype = '';
  String reason = '';
  String status = '';
  String applieddate = '';

  Helper helper = Helper();

  late TextEditingController leaveDateFromController;
  late TextEditingController leaveDateToController;
  late TextEditingController reasonController;
  late String? selectedLeaveType;

  List<LeaveModel> userleaves = [];

  @override
  void initState() {
    selectedLeaveType = 'Service Incentive Leave';
    _getLeave();
    super.initState();
    leaveDateFromController = TextEditingController();
    leaveDateToController = TextEditingController();
    reasonController = TextEditingController();
  }

  Future<void> _getLeave() async {
    final response = await Leave().getleave(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var leaveinfo in json.decode(jsondata)) {
        setState(() {
          LeaveModel userleave = LeaveModel(
              leaveinfo['leaveid'],
              leaveinfo['employeeid'],
              _formatDate(leaveinfo['leavestartdate']),
              _formatDate(leaveinfo['leaveenddate']),
              leaveinfo['leavetype'],
              leaveinfo['reason'],
              leaveinfo['status'],
              leaveinfo['applieddate']);
          userleaves.add(userleave);
        });
      }

      print(userleaves[0].employeeid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaves',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 215, 36, 24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DrawerApp()),
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: userleaves.length,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: const Text(
                                    'Leave Details',
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
                                    '${userleaves[index].leavetype}',
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
                                    'Start Date:     ${userleaves[index].leavestartdate}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'End Date:     ${userleaves[index].leaveenddate}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Applied Date: ${userleaves[index].applieddate}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Reason: ${userleaves[index].reason}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Status: ${userleaves[index].status}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: userleaves[index].status ==
                                              'Pending'
                                          ? Colors.orange
                                          : userleaves[index].status ==
                                                  'Approved'
                                              ? Colors.green
                                              : userleaves[index].status ==
                                                      'Rejected'
                                                  ? Colors.red
                                                  : userleaves[index].status ==
                                                          'Cancel'
                                                      ? Colors.red
                                                      : Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50), // Add some space

                                // Conditionally show the button based on the status
                                if (userleaves[index].status == 'Pending')
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add your button functionality here
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        minimumSize: Size(250, 50),
                                      ),
                                      child: Text(
                                        'Cancel Leave Application',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
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
                                userleaves[index].leavetype,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 7.0),
                                  Text(
                                    '${userleaves[index].leavestartdate} to ${userleaves[index].leaveenddate}',
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Applied Date: ${userleaves[index].applieddate}',
                                  )
                                ],
                              ),
                              trailing: Text(
                                (userleaves[index].status),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: userleaves[index].status == 'Pending'
                                      ? Colors.orange
                                      : userleaves[index].status == 'Approved'
                                          ? Colors.green
                                          : userleaves[index].status ==
                                                  'Rejected'
                                              ? Colors.red
                                              : userleaves[index].status ==
                                                      'Cancel'
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLeaveApplicationForm(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 215, 36, 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  ///MODAL

  Future<void> _showLeaveApplicationForm(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Application'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedLeaveType,
                  decoration: const InputDecoration(labelText: 'Leave Type'),
                  items: <String>[
                    'Service Incentive Leave',
                    'Vacation Leave',
                    'Sick Leave',
                    'Maternity Leave',
                    'Paternity Leave',
                    'Solo Parent Leave'
                  ] // Add your leave types here
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedLeaveType = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: leaveDateFromController,
                  decoration:
                      const InputDecoration(labelText: 'Leave Date From'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: leaveDateToController,
                  decoration: const InputDecoration(labelText: 'Leave Date To'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Handle submit logic here
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
