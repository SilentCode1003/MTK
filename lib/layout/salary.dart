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
      home: Scaffold(),
    );
  }
}
