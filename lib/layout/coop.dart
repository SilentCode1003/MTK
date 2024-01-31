import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:eportal/model/internet_checker.dart';

void main() {
  runApp(const Coop());
}

class Coop extends StatelessWidget {
  const Coop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);

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
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerApp()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
