import 'dart:convert';

import 'package:eportal/api/leave.dart';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class RequestLeave extends StatefulWidget {
  final String employeeid;

  const RequestLeave({Key? key, required this.employeeid}) : super(key: key);

  @override
  State<RequestLeave> createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  String jobstatus = ''; // Add this line to define jobstatus
  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.yMMMd('en_US').format(dateTime);
  }

  String leaveid = '';
  String leavestartdate = '';
  String leaveenddate = '';
  String? leavetype = '';
  String reason = '';
  String status = '';
  String applieddate = '';
  String fullname = '';
  String employeeid = '';
  String image = '';
  int department = 0;
  String departmentname = '';
  String position = '';
  Map<String, dynamic> userinfo = {};
  bool isLoading = true;

  Helper helper = Helper();

  late TextEditingController leaveDateFromController;
  late TextEditingController leaveDateToController;
  late TextEditingController reasonController;
  late String? selectedLeaveType;

  List<LeaveModel> userleaves = [];

  @override
  void initState() {
    selectedLeaveType = 'Service Incentive Leave';
    _getUserInfo();
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
    }
  }

  Future<void> _getUserInfo() async {
    userinfo = await helper.readJsonToFile('metadata.json');
    UserInfoModel user = UserInfoModel(
      userinfo['image'],
      userinfo['employeeid'],
      userinfo['fullname'],
      userinfo['accesstype'],
      userinfo['department'],
      userinfo['departmentname'],
      userinfo['position'],
      userinfo['jobstatus'],
    );

    setState(() {
      fullname = user.fullname;
      employeeid = user.employeeid;
      image = user.image;
      department = user.department;
      departmentname = user.departmentname;
      position = user.position;
      jobstatus = user.jobstatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (jobstatus == 'probitionary') {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Leaves',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerApp()),
              );
            },
          ),
        ),
        body: Center(
          child: Text(
            'No leave assignment for probationary employees.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaves',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
            child: userleaves.isEmpty
                ? Center(
                    child: Text(
                      'No leave applications',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    : userleaves[index]
                                                                .status ==
                                                            'Rejected'
                                                        ? Colors.red
                                                        : userleaves[index]
                                                                    .status ==
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
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom:
                                                    20), // Adjust the margin value as needed
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
                                        )
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        color: userleaves[index].status ==
                                                'Pending'
                                            ? Colors.orange
                                            : userleaves[index].status ==
                                                    'Approved'
                                                ? Colors.green
                                                : userleaves[index].status ==
                                                        'Rejected'
                                                    ? Colors.red
                                                    : userleaves[index]
                                                                .status ==
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
          ),
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
    TextEditingController _startDateController = TextEditingController();
    TextEditingController _endDateController = TextEditingController();
    TextEditingController _reasonController = TextEditingController();
    String? selectedLeaveType;

    Future<void> _requestleave() async {
      String startdate = _startDateController.text;
      String enddate = _endDateController.text;
      String reason = _reasonController.text;

      print('$startdate $enddate $reason $leavetype');

      try {
        final response = await Leave().request(widget.employeeid, startdate,
            enddate, selectedLeaveType.toString(), reason);

        if (response.status == 200) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close the success dialog
                    _getLeave();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Error'),
              content: Text(response.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // Validate function
        bool _validateFields() {
          // Add your validation logic here.
          // For example, check if the selectedLeaveType, startDate, endDate, and reason are not empty.
          return selectedLeaveType != null &&
              _startDateController.text.isNotEmpty &&
              _endDateController.text.isNotEmpty &&
              _reasonController.text.isNotEmpty;
        }

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
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedLeaveType = value;
                      leavetype = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      _startDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      _endDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_validateFields()) {
                  _requestleave();
                } else {
                  // Show an alert indicating that all fields must be filled.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Incomplete Form'),
                        content: Text(
                            'Please fill up all the required fields before submitting.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}
