import 'package:flutter/material.dart';
import 'package:eportal/api/payslip.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';

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
  double Total_Netpay = 0;
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
  dynamic ApprovedNormalOt;
  dynamic ApprovedNightDiffOt;
  dynamic ApprovedEarlyOt;
  dynamic totalHolidayCompensation;

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
      final pdf = pw.Document();
      ByteData imageData = await rootBundle.load('assets/5L.png');
      Uint8List bytes = Uint8List.view(imageData.buffer);

      final pdfImage = pw.MemoryImage(bytes);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                          width: 100, height: 100, child: pw.Image(pdfImage)),
                      pw.Container(
                        padding: const pw.EdgeInsets.only(left: 2.0),
                        child: pw.Text(
                          '5L Solutions Supply & Allied Services Corp',
                          style: const pw.TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 1),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Payslip',
                        style: const pw.TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 7),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        '$StartDate - $Enddate',
                        style: const pw.TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Name: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '$EmployeeFullName',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Container(
                        width: 250,
                        height: 20,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'SSS: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '1234567889',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Employee ID: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '$employeeid',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'TIN: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '1234567890',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Department: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '$Department',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'PhilHealth: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '1234567890',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Position: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '$PositionName',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Container(
                        width: 250, // Adjust width as needed
                        height: 20, // Adjust height as needed
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Pag-Ibig: ',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                            pw.Text(
                              '1234567890',
                              style: const pw.TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 253, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 5.0),
                              child: pw.Text(
                                'COMPENSATION',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(right: 5.0),
                              child: pw.Text(
                                'AMOUNT',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        width: 252, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 5.0),
                              child: pw.Text(
                                'DEDUCTION',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(right: 5.0),
                              child: pw.Text(
                                'AMOUNT',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 253, // Adjust width as needed
                        height: 275, // Adjust height as needed
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            pw.SizedBox(height: 10),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Basic Salary:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$Salary',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Allowance:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$Allowances',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Holiday:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$totalHolidayCompensation',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'OverTime',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$ApprovedOt',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Night Differential',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$ApprovedNightDiffOt',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        width: 253, // Adjust width as needed
                        height: 275, // Adjust height as needed
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            pw.SizedBox(height: 10),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Absences:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$Absent_Deductions',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Late/Undertime:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$Late_Deductions',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'SSS:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$SSS',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'SSS Loan:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '0',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'PhilHealth:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$PhilHealth',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'HDMF:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$PagIbig',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'HDMF Loan:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '0',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Tax:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$TIN',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Health Card:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '$Health_Card',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Cash Advance:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '0',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Coop Contribution:',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '0',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Text(
                                    'Coop Loan',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(right: 5.0),
                                  child: pw.Text(
                                    '0',
                                    style: const pw.TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 253, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 5.0),
                              child: pw.Text(
                                'TOTAL COMPENSATION:',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(right: 5.0),
                              child: pw.Text(
                                '$Overall_Net_Pay',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        width: 253, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 5.0),
                              child: pw.Text(
                                'TOTAL DEDUCTION:',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(right: 5.0),
                              child: pw.Text(
                                '$Total_AllDeductions',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 506,
                        height: 30,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1.0,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 5.0),
                              child: pw.Text(
                                'TOTAL NETPAY:',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(right: 5.0),
                              child: pw.Text(
                                '$Total_Netpay',
                                style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold),
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

      pdf.save();

      // final String dir = (await getExternalStorageDirectory())!.path;
      final dir = await getDownloadDir();
      // final Directory? dir = await getExternalStorageDirectory();
      String filepath = '$dir/Download/payslip.pdf';
      int count = 1;
      while (await File(filepath).exists()) {
        filepath = '$dir/Download/payslip($count).pdf';
        count++;
      }

      print(filepath);

      final File file = File(filepath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded successfully as $filepath'),
          duration: const Duration(seconds: 2),
        ),
      );
       OpenFile.open(filepath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download PDF: $e'),
          duration: const Duration(seconds: 10),
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
            payslipInfo['ApprovedNormalOt'],
            payslipInfo['ApprovedNightDiffOt'],
            payslipInfo['ApprovedEarlyOt'],
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
          ApprovedNormalOt = payslipinfo.ApprovedNormalOt;
          ApprovedNightDiffOt = payslipinfo.ApprovedNightDiffOt;
          ApprovedEarlyOt = payslipinfo.ApprovedEarlyOt;
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

          totalHolidayCompensation =
              Regular_Holiday_Compensation + Special_Holiday_Compensation;
          print('Total Holiday Compensation: $totalHolidayCompensation');
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
          iconTheme: IconThemeData(
              color: Colors.black),
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
                        '₱ ${toCurrencyString(Total_Netpay.toString())}',
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
                          '${toCurrencyString(Salary.toString())}',
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
                          'Allowance:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${toCurrencyString(Allowances.toString())}',
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
                          '${toCurrencyString(totalHolidayCompensation.toString())}',
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
                          '${toCurrencyString(ApprovedOt.toString())}',
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
                          '$ApprovedNightDiffOt',
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
                          '${toCurrencyString(Overall_Net_Pay.toString())} ',
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
                          '${toCurrencyString(Absent_Deductions.toString())}',
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
                          '${toCurrencyString(Late_Deductions.toString())}',
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
                          '${toCurrencyString(SSS.toString())}',
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
                          '${toCurrencyString(PhilHealth.toString())}',
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
                          '${toCurrencyString(PagIbig.toString())}',
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
                          '${toCurrencyString(TIN.toString())}',
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
                          '${toCurrencyString(Health_Card.toString())}',
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
                          '${toCurrencyString(Total_AllDeductions.toString())}',
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
