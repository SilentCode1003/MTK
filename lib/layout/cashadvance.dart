import 'package:eportal/layout/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Cash());
}

class Cashpage extends StatelessWidget {
  const Cashpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Cash(),
    );
  }
}

class Cash extends StatelessWidget {
  const Cash({super.key});

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
            'Cash Loans',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 215, 36, 24),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrawerApp()),
              );
            },
          ),
        ),
        //body: const Coop(),
      ),
    );
  }
}
