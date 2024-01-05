import 'package:flutter/material.dart';

void main() {
  runApp(const Coop());
}

class Coop extends StatelessWidget {
  const Coop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5L SOLUTION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const Coop(),
    );
  }
}

