import 'dart:convert';

import 'package:eportal/api/leave.dart';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';

class RequestLeave extends StatefulWidget {
  final String employeeid;

  const RequestLeave({Key? key, required this.employeeid}) : super(key: key);

  @override
  State<RequestLeave> createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  String jobstatus = '';
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
    _getLeave();
    super.initState();
    leaveDateFromController = TextEditingController();
    leaveDateToController = TextEditingController();
    reasonController = TextEditingController();
    _checkDeveloperOptions();
  }

      void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
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

  Future<void> _cancelLeaveApplication(String leaveId) async {
    try {
      final response =
          await Leave().updaterequest(employeeid, leaveId, 'cancelled');
      if (response.status == 200) {
        // Show a success dialog or handle success accordingly
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: Text(response.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  userleaves.clear();
                  _getLeave(); // Refresh the leave list
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show an error dialog or handle error accordingly
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Errors'),
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
      // Handle exceptions or errors
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

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    if (jobstatus == 'probitionary') {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Leaves',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DrawerPage()),
              );
            },
          ),
        ),
        body: const Center(
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DrawerPage()),
            );
          },
        ),
      ),
      body: Container(
      color: const Color.fromARGB(255, 255, 255, 255),
     child: Column(
        children: <Widget>[
          Expanded(
            child: userleaves.isEmpty
                ? const Center(
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
                          print('Leave ID: ${userleaves[index].leaveid}');
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Container(
                                decoration: const BoxDecoration(
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
                                      const Center(
                                        child: Text(
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
                                          userleaves[index].leavetype,
                                          style: const TextStyle(
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
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'End Date:     ${userleaves[index].leaveenddate}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Applied Date: ${userleaves[index].applieddate}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Reason: ${userleaves[index].reason}',
                                          style: const TextStyle(
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
                                                                'Cancelled'
                                                            ? Colors.red
                                                            : Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 50), // Add some space

                                      // Conditionally show the button based on the status
                                      if (userleaves[index].status == 'Pending')
                                        Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom:
                                                    20), // Adjust the margin value as needed
                                            child: ElevatedButton(
                                              onPressed: () {
                                                print(
                                                    'Leave ID: ${userleaves[index].leaveid}');
                                                // Call the method to cancel leave application
                                                _cancelLeaveApplication(
                                                    userleaves[index]
                                                        .leaveid
                                                        .toString());
                                                // Close the bottom sheet
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                minimumSize: const Size(250, 50),
                                              ),
                                              child: const Text(
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
                                      style: const TextStyle(
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
                                        const SizedBox(height: 7.0),
                                        Text(
                                          '${userleaves[index].leavestartdate} to ${userleaves[index].leaveenddate}',
                                        ),
                                        const SizedBox(height: 5.0),
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
          ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLeaveApplicationForm(context);
        },
        backgroundColor: const Color.fromARGB(255, 215, 36, 24),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showLeaveApplicationForm(BuildContext context) async {
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    String? selectedLeaveType;

    Future<void> _requestleave() async {
      String startdate = startDateController.text;
      String enddate = endDateController.text;
      String reason = reasonController.text;

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
                    Navigator.pop(ctx);
                    Navigator.of(context).pop();
                    userleaves.clear();
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
              startDateController.text.isNotEmpty &&
              endDateController.text.isNotEmpty &&
              reasonController.text.isNotEmpty;
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
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      startDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      endDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
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
                if (_validateFields()) {
                  _requestleave();
                } else {
                  // Show an alert indicating that all fields must be filled.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Form'),
                        content: const Text(
                            'Please fill up all the required fields before submitting.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
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
  const ShimmerLoading({super.key});

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
