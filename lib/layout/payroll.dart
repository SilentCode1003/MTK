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
          String formattedDate =
              _formatDate(payrolldateinfo['gp_payrolldate'].toString());
          String gpCutoff = payrolldateinfo['gp_cutoff'].toString();
          PayrolldateModel userot = PayrolldateModel(formattedDate, gpCutoff);
          dateinfo.add(userot);
          filteredDateInfo = List.from(dateinfo); // Initialize filteredDateInfo
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
    return Scaffold(
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
                      'Payroll',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text(
                                  'Select Date',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              ...dateinfo.map((PayrolldateModel item) =>
                                  DropdownMenuItem<String>(
                                    value: item.gp_payrolldate,
                                    child: Text(
                                      item.gp_payrolldate,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                            ],
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                                filteredDateInfo = dateinfo
                                    .where((element) =>
                                        element.gp_payrolldate == selectedValue)
                                    .toList();
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                              ),
                              elevation: 0,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  // const Padding(
                  //   padding:
                  //       EdgeInsets.only(left: 16.0, top: 13.0, bottom: 8.0),
                  //   child: Text(
                  //     'Recent Payroll',
                  //     style: TextStyle(
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: filteredDateInfo.isEmpty
                        ? const Center(
                            child: Text(
                              'No Payroll found.',
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredDateInfo.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => Payslipdetails(
                                        employeeid: employeeid,
                                        gp_payrolldate: filteredDateInfo[index]
                                            .gp_payrolldate,
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
                                              filteredDateInfo[index].gp_cutoff,
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
                                                  filteredDateInfo[index]
                                                      .gp_payrolldate,
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
    );
  }
}
