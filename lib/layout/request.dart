import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/layout/requestleave.dart';
import 'package:eportal/layout/overtime.dart';
import 'package:eportal/layout/cashadvance.dart';
import 'package:eportal/layout/coa.dart';
import 'package:eportal/layout/undertime.dart';

class Request extends StatefulWidget {
  final String employeeid;
  final String jobstatus;
  const Request({super.key, required this.employeeid, required this.jobstatus});

  @override
  State<Request> createState() => RequestState();
}

class RequestState extends State<Request> {
  String employeeid = '';
  String jobstatus = '';

  @override
  void initState() {
    super.initState();
    employeeid = widget.employeeid;
    jobstatus = widget.jobstatus;
    print(jobstatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
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
        child: Stack(
          children: [
            const Positioned(
              left: 35.0,
              top: 16.0,
              child: Text(
                'Create New Request',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black, // Adding color gray
                ),
              ),
            ),
            Positioned(
              left: 35.0,
              top: 50.0,
              child: GestureDetector(
                onTap: () {
                  if (jobstatus == 'regular') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RequestLeave(employeeid: employeeid)),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sorry'),
                        content: const Text('Your job status isn\'t regular.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  height: 65.0,
                  width: MediaQuery.of(context).size.width - 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 0),
                        child: Icon(
                          Icons.assessment_outlined,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Leaves',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Apply for a vacation leave, sick leave, etc.',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 35.0,
              top: 125.0,
              child: GestureDetector(
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => COA(employeeid: employeeid)));
                },
                child: Container(
                  height: 65.0,
                  width: MediaQuery.of(context).size.width - 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 0),
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Certificate of Attendance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Submit a log for missed attendance instances',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),  
            Positioned(
              left: 35.0,
              top: 200.0,
              child: GestureDetector(
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Overtime(employeeid: employeeid)));
                },
                child: Container(
                  height: 65.0,
                  width: MediaQuery.of(context).size.width - 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 0),
                        child: Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Overtime',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Record hours worked beyond your scheduled shift',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 35.0,
              top: 275.0,
              child: GestureDetector(
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UnderTime(employeeid: employeeid)));
                },
                child: Container(
                  height: 65.0,
                  width: MediaQuery.of(context).size.width - 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 0),
                        child: Icon(
                          Icons.access_time,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Undertime',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Record hours worked below your scheduled shift.',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 35.0,
              top: 350.0,
              child: GestureDetector(
                onTap: () {
                   if (jobstatus == 'regular') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RequestCash(employeeid: employeeid)),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sorry'),
                        content: const Text('Your job status isn\'t regular.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  height: 65.0,
                  width: MediaQuery.of(context).size.width - 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 0),
                        child: Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cash Advance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Apply Cash Advance Instant funds',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Add other widgets to the Stack if needed
          ],
        ),
      ),
    );
  }
}
