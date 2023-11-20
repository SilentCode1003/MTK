import 'package:flutter/material.dart';
import 'package:eportal/main.dart';
import 'package:eportal/layout/cashadvance.dart';
import 'package:eportal/layout/coop.dart';
import 'package:eportal/layout/notice.dart';
import 'package:eportal/layout/requestleave.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5L SOLUTION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    DashboardPage(),
    AttendancePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '5L SOLUTION',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 215, 36, 24), // Set the app bar color to red
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
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
              Navigator.pushReplacement( 
              context,
              MaterialPageRoute(builder: (context) => Coop()), // Replace Login() with your actual login page class
              );
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

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Payslip',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Dashboard Page Content'),
          SizedBox(height: 20),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 215, 36, 24),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Show the small form as a popup
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          height: 300.0, // Set the desired height
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              // Add your form widgets here
                              // For example, you can use TextFormField, RaisedButton, etc.
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Username'),
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Password'),
                                obscureText: true,
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // Add functionality for the login button here
                                  // You can close the modal sheet using Navigator.pop(context)
                                  Navigator.pop(context);
                                },
                                child: Text('Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: Colors.transparent,
                onPrimary: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Attendance'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Payslip Page Content'),
    );
  }
}