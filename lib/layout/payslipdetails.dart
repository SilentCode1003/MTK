import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/api/payslip.dart';
import 'dart:convert';
import 'package:eportal/repository/helper.dart';
import 'package:eportal/model/userinfo.dart';

class Payslipdetails extends StatefulWidget {
  final String employeeid;
  final String gp_payrolldate;
  const Payslipdetails(
      {super.key, required this.employeeid, required this.gp_payrolldate});

  @override
  State<Payslipdetails> createState() => _PayslipdetailsState();
}

class _PayslipdetailsState extends State<Payslipdetails> {
  dynamic employeeid ;
  dynamic gp_payrolldate ;
  dynamic PayrollDate ;
  dynamic StartDate ;
  dynamic Enddate ;
  dynamic Salary ;
  dynamic Allowances ;
  dynamic Regular_Holiday_Compensation ;
  dynamic Special_Holiday_Compensation ;
  dynamic RegularHolidayOT ;
  dynamic SpecialHolidayOT ;
  dynamic EarlyOtpay ;
  dynamic OTpay ;
  dynamic NDpay ;
  dynamic Overall_Net_Pay ;
  dynamic Absent_Deductions ;
  dynamic Late_Deductions ;
  dynamic SSS ;
  dynamic PhilHealth ;
  dynamic PagIbig ;
  dynamic TIN ;
  dynamic Health_Card ;
  dynamic Total_AllDeductions ;
  dynamic Total_Netpay ;
  dynamic EmployeeFullName ;
  dynamic PositionName ;
  dynamic Department ;
  dynamic Total_Hours ;
  dynamic EarlyOt ;
  dynamic Late_Minutes ;
  dynamic HolidayOvertime ;
  dynamic Late_Hours ;
  dynamic Regular_Hours ;
  dynamic Per_Day ;
  dynamic Work_Days ;
  dynamic Rest_Day ;
  dynamic Total_gp_status ;
  dynamic Absent ;
  dynamic Compensation ;
  dynamic ApprovedOt ;



  Helper helper = Helper();
  
  List<PayslipModel> payslipinfo = [];

  @override
  void initState() {
    employeeid = widget.employeeid;
    PayrollDate = widget.gp_payrolldate;
    super.initState();
    print(employeeid);
    print(PayrollDate);
    _getPayslipInfo();
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
            payslipInfo['StartDate'],
            payslipInfo['Enddate'],
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
          Regular_Holiday_Compensation = payslipinfo.Regular_Holiday_Compensation;
          Special_Holiday_Compensation = payslipinfo.Special_Holiday_Compensation;
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
      print(employeeid);
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
              padding:
                  const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: const Icon(Icons.download, color: Colors.black,),
                onPressed: () {
                
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
