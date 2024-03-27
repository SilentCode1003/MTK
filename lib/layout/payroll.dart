import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';
import 'package:eportal/api/payslip.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:eportal/layout/payslip.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eportal/layout/notification.dart';
import 'package:badges/badges.dart' as badges;

class Salary extends StatefulWidget {
  final String employeeid;
  const Salary({Key? key, required this.employeeid}) : super(key: key);

  @override
  _SalaryState createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  String employeeid = '';
  String gp_payrolldate = '';
  String gp_cutoff = '';
  String cutoffdate = '';
  String? selectedValue;

  List<PayrolldateModel> dateinfo = [];
  List<PayrolldateModel> filteredDateInfo = [];
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    checkInternetConnection(context);
    _checkDeveloperOptions();
    getpayrolldate();
    employeeid = widget.employeeid;
    print(employeeid);
  }

  String _formatDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  String _formatDateMMMdd(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('MMMM dd').format(dateTime);
  }

  String _formatDateRange(String dateRange) {
    List<String> dateParts = dateRange.split(' To ');
    DateTime startDate = DateTime.parse(dateParts[0]);
    DateTime endDate = DateTime.parse(dateParts[1]);
    String formattedStartDate = DateFormat('MMMM dd').format(startDate);
    String formattedEndDate = DateFormat('MMMM dd').format(endDate);
    return '$formattedStartDate - $formattedEndDate';
  }

  Future<void> getpayrolldate() async {
    final response = await Payroll().getdate(gp_payrolldate);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var payrolldateinfo in json.decode(jsondata)) {
        setState(() {
          String formattedDate = payrolldateinfo['gp_payrolldate'].toString();
          String gpCutoff = payrolldateinfo['gp_cutoff'].toString();
          String DateRange = payrolldateinfo['DateRange'].toString();

          String formattedDateRange = _formatDateRange(DateRange);

          PayrolldateModel userot =
              PayrolldateModel(formattedDate, gpCutoff, formattedDateRange);
          dateinfo.add(userot);
          filteredDateInfo = List.from(dateinfo);
        });
      }
      print(dateinfo);
    }
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payroll', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(right: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
                badgeContent: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 25.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Notifications(
                          employeeid: widget.employeeid,
                        ),
                      ),
                    );
                  },
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.76,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDateInfo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => Payslipdetails(
                                  employeeid: employeeid,
                                  gp_payrolldate:
                                      filteredDateInfo[index].gp_payrolldate,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 85,
                            width: 350,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1),
                                  )
                                ]),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 15,
                                  top: 20,
                                  child: Icon(
                                    Icons.file_open_outlined,
                                    size: 40,
                                  ),
                                ),
                                Positioned(
                                  left: 75,
                                  top: 20,
                                  child: Text(
                                    filteredDateInfo[index].gp_payrolldate,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 75,
                                  top: 45,
                                  child: Text(
                                    filteredDateInfo[index].DateRange,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 25,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 30,
                                  ),
                                ),
                              ],
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
    );
  }
}
