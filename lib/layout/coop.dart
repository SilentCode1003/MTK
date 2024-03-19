import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';

class Coop extends StatefulWidget {
  const Coop({Key? key}) : super(key: key);

  @override
  State<Coop> createState() => _CoopState();
}

class _CoopState extends State<Coop> {
  DateTime? _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDatePickerMode:
          DatePickerMode.year, // Set initial mode to show only years
      fieldHintText: '', // Hide month and day selectors
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Print only the year
      print('Selected Year: ${_selectedDate!.year}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cooperative',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.blue, // Example color, you can change it
              child: Center(
                child: Text(
                  'Container 1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.green,
              child: Center(
                child: Text(
                  'Container 2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
