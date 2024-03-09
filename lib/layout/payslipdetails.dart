import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/api/payslip.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class Payslipdetails extends StatefulWidget {
  final String employeeid;
  final String gp_payrolldate;
  const Payslipdetails(
      {super.key, required this.employeeid, required this.gp_payrolldate});

  @override
  State<Payslipdetails> createState() => _PayslipdetailsState();
}

class _PayslipdetailsState extends State<Payslipdetails> {
  dynamic employeeid;
  dynamic gp_payrolldate;
  dynamic PayrollDate;
  dynamic StartDate;
  dynamic Enddate;
  dynamic Salary;
  dynamic Allowances;
  dynamic Regular_Holiday_Compensation;
  dynamic Special_Holiday_Compensation;
  dynamic RegularHolidayOT;
  dynamic SpecialHolidayOT;
  dynamic EarlyOtpay;
  dynamic OTpay;
  dynamic NDpay;
  dynamic Overall_Net_Pay;
  dynamic Absent_Deductions;
  dynamic Late_Deductions;
  dynamic SSS;
  dynamic PhilHealth;
  dynamic PagIbig;
  dynamic TIN;
  dynamic Health_Card;
  dynamic Total_AllDeductions;
  dynamic Total_Netpay;
  dynamic EmployeeFullName;
  dynamic PositionName;
  dynamic Department;
  dynamic Total_Hours;
  dynamic EarlyOt;
  dynamic Late_Minutes;
  dynamic HolidayOvertime;
  dynamic Late_Hours;
  dynamic Regular_Hours;
  dynamic Per_Day;
  dynamic Work_Days;
  dynamic Rest_Day;
  dynamic Total_gp_status;
  dynamic Absent;
  dynamic Compensation;
  dynamic ApprovedOt;

  Helper helper = Helper();

  List<PayslipModel> payslipinfo = [];

  String _formatDate(String? date) {
    if (date == "" || date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMMM dd yyyy', 'en_US').format(dateTime);
  }

  @override
  void initState() {
    employeeid = widget.employeeid;
    PayrollDate = widget.gp_payrolldate;
    super.initState();
    print(employeeid);
    print(PayrollDate);
    _getPayslipInfo();
  }

  Future<void> _generatePDF(BuildContext context) async {
    try {
      final pdf = pdfLib.Document();

      final image = pdfLib.MemoryImage(File('assets/5L.png').readAsBytesSync(),
      );

      pdf.addPage(
        pdfLib.Page(
          build: (context) {
            return pdfLib.Container(
              child: pdfLib.Column(
                mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                children: [
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                    children: [
                      pdfLib.Container(
                        width: 100,
                        height: 100,
                        child: pdfLib.Image(image),
                      ),
                      pdfLib.Container(
                        padding: pdfLib.EdgeInsets.only(left: 2.0),
                        child: pdfLib.Text(
                          '5L Solutions Supply & Allied Services Corp',
                          style: pdfLib.TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 1),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.center,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                    children: [
                      pdfLib.Text(
                        'Payslip',
                        style: pdfLib.TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 7),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.center,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                    children: [
                      pdfLib.Text(
                        '$StartDate - $Enddate',
                        style: pdfLib.TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 15),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'Name: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '$EmployeeFullName',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pdfLib.SizedBox(width: 5),
                      pdfLib.Container(
                        width: 250,
                        height: 20,
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'SSS: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '1234567889',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 5),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'Employee ID: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '$employeeid',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pdfLib.SizedBox(width: 5),
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'TIN: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '1234567890',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 5),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'Department: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '$Department',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pdfLib.SizedBox(width: 5),
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'PhilHealth: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '1234567890',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 5),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'Position: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '$PositionName',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pdfLib.SizedBox(width: 5),
                      pdfLib.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Text(
                              'Pag-Ibig: ',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                            pdfLib.Text(
                              '1234567890',
                              style: pdfLib.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.SizedBox(height: 20),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 253, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(left: 5.0),
                              child: pdfLib.Text(
                                'COMPENSATION',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(right: 5.0),
                              child: pdfLib.Text(
                                'AMOUNT',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pdfLib.Container(
                        width: 252, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(left: 5.0),
                              child: pdfLib.Text(
                                'DEDUCTION',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(right: 5.0),
                              child: pdfLib.Text(
                                'AMOUNT',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 253, // Adjust width as needed
                        height: 275, // Adjust height as needed
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Column(
                          children: [
                            pdfLib.SizedBox(height: 10),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.center,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Basic Salary:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$Salary',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.center,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Allowance:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$Allowances',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.center,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Holiday:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$RegularHolidayOT',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.center,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'OverTime',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$ApprovedOt',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.center,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Night Differential',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$NDpay',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pdfLib.Container(
                        width: 253, // Adjust width as needed
                        height: 275, // Adjust height as needed
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Column(
                          children: [
                            pdfLib.SizedBox(height: 10),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Absences:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$Absent_Deductions',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Late/Undertime:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$Late_Deductions',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'SSS:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$SSS',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'SSS Loan:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '0',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'PhilHealth:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$PhilHealth',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'HDMF:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$PagIbig',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'HDMF Loan:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$Late_Deductions',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Tax:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$TIN',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Health Card:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '$Health_Card',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Cash Advance:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '0',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Coop Contribution:',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '0',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pdfLib.SizedBox(height: 5),
                            pdfLib.Row(
                              mainAxisAlignment:
                                  pdfLib.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(left: 5.0),
                                  child: pdfLib.Text(
                                    'Coop Loan',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pdfLib.Padding(
                                  padding: pdfLib.EdgeInsets.only(right: 5.0),
                                  child: pdfLib.Text(
                                    '0',
                                    style: pdfLib.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 253, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(left: 5.0),
                              child: pdfLib.Text(
                                'TOTAL COMPENSATION:',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(right: 5.0),
                              child: pdfLib.Text(
                                '$Overall_Net_Pay',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pdfLib.Container(
                        width: 253, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(left: 5.0),
                              child: pdfLib.Text(
                                'TOTAL DEDUCTION:',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(right: 5.0),
                              child: pdfLib.Text(
                                '$Total_AllDeductions',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Container(
                        width: 506,
                        height: 30,
                        decoration: pdfLib.BoxDecoration(
                          border: pdfLib.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pdfLib.Row(
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          children: [
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(left: 5.0),
                              child: pdfLib.Text(
                                'TOTAL NETPAY:',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                            pdfLib.Padding(
                              padding: pdfLib.EdgeInsets.only(right: 5.0),
                              child: pdfLib.Text(
                                '$Total_Netpay',
                                style: pdfLib.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pdfLib.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );

      final String dir = (await getApplicationDocumentsDirectory()).path;
      String path = '$dir/payslip.pdf';
      int count = 1;
      while (await File(path).exists()) {
        path = '$dir/payslip($count).pdf';
        count++;
      }
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded successfully as $path'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download PDF: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _getPayslipInfo() async {
    final response = await Payroll().getpayslip(employeeid, PayrollDate);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var payslipInfo in json.decode(jsondata)) {
        print(payslipInfo['Salary']);
        setState(() {
          PayslipModel payslipinfo = PayslipModel(
            payslipInfo['EmployeeFullName'],
            payslipInfo['PositionName'],
            payslipInfo['Department'],
            payslipInfo['EmployeeId'],
            payslipInfo['Salary'],
            payslipInfo['Allowances'],
            payslipInfo['PayrollDate'],
            _formatDate(payslipInfo['StartDate']),
            _formatDate(payslipInfo['Enddate']),
            payslipInfo['Total_Hours'],
            payslipInfo['Total_Minutes'],
            payslipInfo['NightDiff'],
            payslipInfo['NormalOt'],
            payslipInfo['EarlyOt'],
            payslipInfo['Late_Minutes'],
            payslipInfo['Late_Hours'],
            payslipInfo['HolidayOvertime'],
            payslipInfo['Regular_Hours'],
            payslipInfo['Per_Day'],
            payslipInfo['Work_Days'],
            payslipInfo['Rest_Day'],
            payslipInfo['Total_gp_status'],
            payslipInfo['Absent'],
            payslipInfo['NDpay'],
            payslipInfo['OTpay'],
            payslipInfo['EarlyOtpay'],
            payslipInfo['Compensation'],
            payslipInfo['ApprovedOt'],
            payslipInfo['Regular_Holiday_Compensation'],
            payslipInfo['Special_Holiday_Compensation'],
            payslipInfo['RegularHolidayOT'],
            payslipInfo['SpecialHolidayOT'],
            payslipInfo['Absent_Deductions'],
            payslipInfo['Overall_Net_Pay'],
            payslipInfo['Late_Deductions'],
            payslipInfo['SSS'],
            payslipInfo['PagIbig'],
            payslipInfo['PhilHealth'],
            payslipInfo['TIN'],
            payslipInfo['Health_Card'],
            payslipInfo['Total_AllDeductions'],
            payslipInfo['Total_Netpay'],
          );
          EmployeeFullName = payslipinfo.EmployeeFullName;
          PositionName = payslipinfo.PositionName;
          Department = payslipinfo.Department;
          employeeid = payslipinfo.EmployeeId;
          Salary = payslipinfo.Salary;
          Allowances = payslipinfo.Allowances;
          PayrollDate = payslipinfo.PayrollDate;
          StartDate = payslipinfo.StartDate;
          Enddate = payslipinfo.Enddate;
          Total_Hours = payslipinfo.Total_Hours;
          EarlyOt = payslipinfo.EarlyOt;
          Late_Minutes = payslipinfo.Late_Minutes;
          Late_Hours = payslipinfo.Late_Hours;
          HolidayOvertime = payslipinfo.HolidayOvertime;
          Regular_Hours = payslipinfo.Late_Deductions;
          Per_Day = payslipinfo.Per_Day;
          Work_Days = payslipinfo.Work_Days;
          Rest_Day = payslipinfo.Rest_Day;
          Total_gp_status = payslipinfo.Total_gp_status;
          Absent = payslipinfo.Absent;
          NDpay = payslipinfo.NDpay;
          OTpay = payslipinfo.OTpay;
          EarlyOtpay = payslipinfo.EarlyOtpay;
          Compensation = payslipinfo.Compensation;
          ApprovedOt = payslipinfo.ApprovedOt;
          Regular_Holiday_Compensation =
              payslipinfo.Regular_Holiday_Compensation;
          Special_Holiday_Compensation =
              payslipinfo.Special_Holiday_Compensation;
          RegularHolidayOT = payslipinfo.RegularHolidayOT;
          SpecialHolidayOT = payslipinfo.SpecialHolidayOT;
          Absent_Deductions = payslipinfo.Absent_Deductions;
          Overall_Net_Pay = payslipinfo.Overall_Net_Pay;
          Late_Deductions = payslipinfo.Late_Deductions;
          SSS = payslipinfo.SSS;
          PagIbig = payslipinfo.PagIbig;
          PhilHealth = payslipinfo.PhilHealth;
          TIN = payslipinfo.TIN;
          Health_Card = payslipinfo.Health_Card;
          Total_AllDeductions = payslipinfo.Total_AllDeductions;
          Total_Netpay = payslipinfo.Total_Netpay;
        });
      }
      print('ito ang total $Overall_Net_Pay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Payslip',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                '$StartDate - $Enddate',
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DrawerPage()),
              );
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Colors.black,
                ),
                onPressed: () {
                  _generatePDF(context);
                },
              ),
            ),
          ],
        ),
        body: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        '₱ $Total_Netpay',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'NET PAY',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'COMPENSATION',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Basic Salary: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Salary',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Allowance: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Allowances',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Holiday: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$RegularHolidayOT',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overtime: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$OTpay',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Night Differential: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$NDpay',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL COMPENSATION: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Overall_Net_Pay',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 15),
                    const Text(
                      'DEDUCTION',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Absences: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Absent_Deductions',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Late/Undertime: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Late_Deductions',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SSS: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$SSS',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SSS Loan: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PhilHeath: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$PhilHealth',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'HDMF: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$PagIbig',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'HDMF Loan: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tax: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$TIN',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Heathcare: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Health_Card',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cash Advance: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coop Contribution: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coop Loan: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL DEDUCTION: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$Total_AllDeductions',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
            )));
  }
}
