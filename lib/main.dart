import 'dart:convert';

import 'package:eportal/api/login.dart';
import 'package:eportal/component/loadingspinner.dart';
import 'package:eportal/repository/helper.dart';
import 'package:flutter/material.dart';
//import 'layout/home.dart';
import 'layout/drawer.dart';
//  import 'layout/coop.dart';
//  import 'layout/notice.dart';
//  import 'layout/requestleave.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '5L SOLUTION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(), // Change to LoginPage()
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Helper helper = Helper();

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingSpinner(
            message: 'Loading...',
          );
        });

    final response = await Login().login(username, password);

    print(response.message);

    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsonData = json.encode(response.result);
      for (var userinfo in json.decode(jsonData)) {
        helper.writeJsonToFile(userinfo, 'metadata.json');
      }

      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DrawerApp()),
      );
    } else {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Access'),
          content: const Text('Incorrect username and password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  child: Image.asset('assets/5L.png'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter valid Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15,
                bottom: 15,
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password',
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => DrawerApp()),
                  // );
                  _login();
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(
                      255, 215, 36, 24), // Set the background color to red
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
