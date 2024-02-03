import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eportal/api/login.dart';
import 'package:eportal/repository/helper.dart';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const OpeningPage(),
      routes: {'/logout': ((context) => LoginPage())},
    );
  }
}

class OpeningPage extends StatefulWidget {
  const OpeningPage({Key? key}) : super(key: key);

  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  void initState() {
    super.initState();
    _loadLoginPage();
  }

  Future<void> _loadLoginPage() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 200,
              child: Column(
                children: [
                  Image.asset('assets/5L.png'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  Future<void> _saveRememberedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      isLoading = true;
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await Future.delayed(Duration(seconds: 3)); // Add a 3-second delay
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final response = await Login().login(username, password);

    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsonData = json.encode(response.result);
      for (var userinfo in json.decode(jsonData)) {
        helper.writeJsonToFile(userinfo, 'metadata.json');
      }
      _saveRememberedCredentials();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DrawerApp()),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Access'),
          content: const Text('Incorrect username and password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  bool _isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid || Platform.isIOS) {
                    exit(0);
                  }
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _togglePasswordVisibility();
                      },
                    ),
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
                    _login();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 215, 36, 24),
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            const SizedBox(width: 10),
                          ],
                        )
                      : Text(
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
      ),
    );
  }
}
