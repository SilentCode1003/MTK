import 'package:flutter/material.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';

void main() {
  runApp(const Salary());
}

class Salary extends StatefulWidget {
  const Salary({Key? key}) : super(key: key);

  @override
  _SalaryState createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection(context);
    _checkDeveloperOptions();
  }

    void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
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
                        'Salary',
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
          ],
        ),
      ),
    );
  }

  //date
  Future<void> _showDateRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now()
          .subtract(const Duration(days: 365)), // Set your desired date range
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 215, 36, 24),
            colorScheme: ColorScheme.light(
                primary: const Color.fromARGB(255, 215, 36, 24)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked?.start != null && picked?.end != null) {
      print('Selected date range: ${picked!.start} to ${picked.end}');
    }
  }
}
