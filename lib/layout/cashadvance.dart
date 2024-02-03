import 'dart:convert';

import 'package:eportal/layout/drawer.dart';
import 'package:flutter/material.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/api/cash.dart';
import 'package:eportal/model/internet_checker.dart';

class RequestCash extends StatefulWidget {
  final String employeeid;

  const RequestCash({super.key, required this.employeeid});

  @override
  State<RequestCash> createState() => _RequestCashState();
}

class _RequestCashState extends State<RequestCash> {
  String cashadvanceid = '';
  String employeeid = '';
  String requestdate = '';
  String amount = '';
  String purpose = '';
  String status = '';
  String approvaldate = '';

  Helper helper = Helper();

  late TextEditingController amountController;
  late TextEditingController purposeController;

  List<CashModel> userscash = [];

  @override
  void initState() {
    _getCash();
    super.initState();
    amountController = TextEditingController();
    purposeController = TextEditingController();
  }

  Future<void> _getCash() async {
    final response = await Cash().getcash(widget.employeeid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var cashinfo in json.decode(jsondata)) {
        setState(() {
          CashModel usercash = CashModel(
              cashinfo['cashadvanceid'],
              cashinfo['employeeid'],
              cashinfo['requestdate'],
              cashinfo['amount'],
              cashinfo['purpose'],
              cashinfo['status'],
              cashinfo['approvaldate']);
          userscash.add(usercash);
        });
      }
      print(userscash[0].employeeid);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cash Advance',
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
            child: userscash.isEmpty
                ? Center(
                    child: Text(
                      'No Cash Advance applications',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    itemCount: userscash.length,
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
                                          '₱ ${userscash[index].amount}',
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
                                          'Start Date:     ${userscash[index].requestdate}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'End Date:     ${userscash[index].requestdate}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Applied Date: ${userscash[index].approvaldate}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Reason: ${userscash[index].purpose}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Status: ${userscash[index].status}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: userscash[index].status ==
                                                    'Pending'
                                                ? Colors.orange
                                                : userscash[index].status ==
                                                        'Approved'
                                                    ? Colors.green
                                                    : userscash[index].status ==
                                                            'Rejected'
                                                        ? Colors.red
                                                        : userscash[index]
                                                                    .status ==
                                                                'Cancel'
                                                            ? Colors.red
                                                            : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50), // Add some space

                                      // Conditionally show the button based on the status
                                      if (userscash[index].status == 'Pending')
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
                                              'Cancel Cash Application',
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
                                      '₱ ${userscash[index].amount}',
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
                                          'Approved Date: ${userscash[index].approvaldate}',
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          'Applied Date: ${userscash[index].requestdate}',
                                        )
                                      ],
                                    ),
                                    trailing: Text(
                                      (userscash[index].status),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: userscash[index].status ==
                                                'Pending'
                                            ? Colors.orange
                                            : userscash[index].status ==
                                                    'Approved'
                                                ? Colors.green
                                                : userscash[index].status ==
                                                        'Rejected'
                                                    ? Colors.red
                                                    : userscash[index].status ==
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
          _showCashApplicationForm(context);
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

  Future<void> _showCashApplicationForm(BuildContext context) async {
    TextEditingController _amountController = TextEditingController();
    TextEditingController _purposeController = TextEditingController();

    Future<void> _requestcash() async {
      String amount = _amountController.text;
      String purpose = _purposeController.text;

      print('$amount $purpose');

      try {
        final response =
            await Cash().request(widget.employeeid, amount, purpose);

        if (response.status == 200) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                     _getCash();
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
          return _amountController.text.isNotEmpty &&
              _purposeController.text.isNotEmpty;
        }

        return AlertDialog(
          title: const Text('Cash Advance'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _amountController,
                  decoration:
                      const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_validateFields()) {
                  _requestcash();
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
