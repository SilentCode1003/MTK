import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';
import 'package:eportal/api/payslip.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/layout/payslipdetails.dart';

class Salary extends StatefulWidget {
  final String employeeid;
  const Salary({super.key, required this.employeeid});

  @override
  _SalaryState createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  String employeeid = '';
  String gp_payrolldate = '';
  String gp_cutoff = '';
  String cutoffdate = '';

  Helper helper = Helper();
  List<PayrolldateModel> dateinfo = [];

  @override
  void initState() {
    super.initState();
    checkInternetConnection(context);
    _checkDeveloperOptions();
    getpayrolldate();
    employeeid = widget.employeeid;
    print(employeeid);
  }

  String _formatDate(String? date) {
    if (date == "" || date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd', 'en_US').format(dateTime);
  }

Future<void> getpayrolldate() async {
  final response = await Payroll().getdate(gp_payrolldate);
  if (helper.getStatusString(APIStatus.success) == response.message) {
    final jsondata = json.encode(response.result);
    for (var payrolldateinfo in json.decode(jsondata)) {
      setState(() {
        String formattedDate = _formatDate(payrolldateinfo['gp_payrolldate'].toString());
        String gpCutoff = payrolldateinfo['gp_cutoff'].toString();
        PayrolldateModel userot = PayrolldateModel(formattedDate, gpCutoff);
        dateinfo.add(userot);
      });
    }
    print(dateinfo);
  }
}


  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color.fromARGB(255, 215, 36, 24),
              colorScheme: const ColorScheme.light(
                  primary: Color.fromARGB(255, 215, 36, 24)),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });

    if (picked?.start != null && picked?.end != null) {
      setState(() {
        // selectedDateRange = picked;
        // usersattendance.clear();
      });

      // _filterAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payslip',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDateRangePicker(context);
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, -2),
                      blurRadius: 5.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 13.0, bottom: 8.0),
                      child: Text(
                        'Recent Payslip',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: dateinfo.isEmpty
                          ? const Center(
                              child: Text(
                                'No Payslip',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          : ListView.builder(
                              itemCount: dateinfo.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => Payslipdetails(
                                          employeeid: employeeid,
                                          gp_payrolldate:
                                              dateinfo[index].gp_payrolldate,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          const SizedBox(width: 10.0),
                                          const Icon(Icons.calendar_today),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                '${dateinfo[index].gp_cutoff}',
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
                                                    '${dateinfo[index].gp_payrolldate}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward_ios),
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
            ),
          ],
        ),
      ),
    );
  }
}
