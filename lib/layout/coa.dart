import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:intl/intl.dart';
import 'package:eportal/api/attendance.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class COA extends StatefulWidget {
  final String employeeid;

  const COA({super.key, required this.employeeid});

  @override
  State<COA> createState() => _COAtState();
}

class _COAtState extends State<COA> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController TimeInController = TextEditingController();
  TextEditingController TimeOutController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  String? selectedFileName;
  File? selectedFile;
  String _fileattachment = '';

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        selectedFileName = result.files.single.name;
      });

      if (selectedFile != null) {
        List<int> fileBytes = await selectedFile!.readAsBytes();
        String base64File = base64Encode(fileBytes);

        setState(() {
          _fileattachment = base64File;
        });
        print(base64File);
      }
    } else {}
  }

  void _removeSelectedFile() {
    setState(() {
      selectedFileName = null;
    });
  }

  Future<void> _requestcoa() async {
    String attendancedate = startDateController.text;
    String timein = TimeInController.text;
    String timeout = TimeOutController.text;
    String reason = reasonController.text;

    String In = timein + ' ' + timeout;

    if (attendancedate.isEmpty ||
        timein.isEmpty ||
        timeout.isEmpty ||
        reason.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill up all fields and select a file.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    DateTime timeIn = DateFormat('yyyy-MM-dd HH:mm').parse(timein);
    DateTime timeOut = DateFormat('yyyy-MM-dd HH:mm').parse(timeout);

    Duration difference = timeOut.difference(timeIn);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    if (hours < 0 || minutes < 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid time range: Time Out must be after Time In'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    print('Duration: $hours hours and $minutes minutes');
    print('$attendancedate $timein $timeout $reason $selectedFileName $In');

    try {
      print(_fileattachment);

      final response = await UserAttendance().coa(
        widget.employeeid,
        attendancedate,
        timein,
        timeout,
        reason,
        _fileattachment,
      );

      if (response.status == 200) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Success'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(response.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            ),
          ],
        ),
      );
      print(e);
      print('Selected file name: $selectedFileName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawerPage()),
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        title: const Text(
          'Certificate of Attendance',
          style: TextStyle(color: Colors.black),
        ),
        leading: const Icon(
          Icons.calendar_month,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    startDateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 170,
                        child: TextFormField(
                          controller: TimeInController,
                          decoration: const InputDecoration(
                            labelText: 'Time In',
                          ),
                          onTap: () async {
                            DateTime? pickedDateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDateTime != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                pickedDateTime = DateTime(
                                  pickedDateTime.year,
                                  pickedDateTime.month,
                                  pickedDateTime.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(pickedDateTime);
                                String formattedTime =
                                    DateFormat('HH:mm').format(pickedDateTime);
                                String formattedDateTime =
                                    "$formattedDate $formattedTime";
                                setState(() {
                                  TimeInController.text = formattedDateTime;
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      "-",
                    ),
                  ),
                  const SizedBox(width: 1),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 170,
                        child: TextFormField(
                          controller: TimeOutController,
                          decoration: const InputDecoration(
                            labelText: 'Time Out',
                          ),
                          onTap: () async {
                            DateTime? pickedDateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDateTime != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                pickedDateTime = DateTime(
                                  pickedDateTime.year,
                                  pickedDateTime.month,
                                  pickedDateTime.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(pickedDateTime);
                                String formattedTime =
                                    DateFormat('HH:mm').format(pickedDateTime);
                                String formattedDateTime =
                                    "$formattedDate $formattedTime";
                                setState(() {
                                  TimeOutController.text = formattedDateTime;
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  TextFormField(
                    controller: reasonController,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 300,
              height: 135,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File attachment',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    if (selectedFileName != null) ...[
                      SizedBox(height: 5),
                      Text(
                        '$selectedFileName',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: _removeSelectedFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Remove File'),
                      ),
                    ] else ...[
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            _openFileExplorer();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: Text(
                            'Upload File',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _requestcoa();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 215, 36, 24),
            ),
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }
}
