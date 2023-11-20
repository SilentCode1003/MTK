import 'package:flutter/material.dart';
import 'package:eportal/main.dart';
import 'package:eportal/layout/home.dart';
import 'package:eportal/layout/cashadvance.dart';
import 'package:eportal/layout/notice.dart';
import 'package:eportal/layout/requestleave.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5L SOLUTION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Coop(),
    );
  }
}

class Coop  extends StatefulWidget {
  const Coop({Key? key}) : super(key: key);

  @override
  _CoopState createState() => _CoopState();
}

class _CoopState extends State<Coop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '5L SOLUTION',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Set the app bar color to red
      ),
      body: Center(
        child: Text('Coop!'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 215, 36, 24), // Set the sidebar header color to red
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.asset(
                'assets/toy.jpg',
                fit: BoxFit.cover,
                width: 80.0,
                height: 80.0,
                ),
                ),
                  SizedBox(height: 15),
                  Text(
                    'Mark Anasarias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()), // Replace Login() with your actual login page class
              );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Cash Advance'),
              onTap: () {
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => cashadvance()), // Replace Login() with your actual login page class
              );

              },
            ),
              ListTile(
              leading: Icon(Icons.business),
              title: Text('Coop'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.request_page),
              title: Text('Request Leave'),
              onTap: () {
               Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => requestleave()), // Replace Login() with your actual login page class
              );
              },
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Deviation Notice'),
              onTap: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => notice()), // Replace Login() with your actual login page class
              );
              },
            ),
            ListTile(
  leading: Icon(Icons.logout),
  title: Text('Logout'),
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                // Perform logout and navigate to LoginPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  },
),
          ],
        ),
      ),
    );
  }
}

