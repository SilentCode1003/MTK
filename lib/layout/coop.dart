import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/component/internet_checker.dart';
import 'package:eportal/component/developer_options_checker.dart';


void main() {
  runApp(const Coop());
}

class Coop extends StatefulWidget {
  const Coop({Key? key}) : super(key: key);

  @override
  _CoopState createState() => _CoopState();
}

class _CoopState extends State<Coop> {
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
      title: '5L SOLUTION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Coop',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DrawerPage()),
              );
            },
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              // Add your widgets here
            ],
          ),
        ),
      ),
    );
  }
}
