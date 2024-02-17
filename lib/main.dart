import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eportal/api/login.dart';
import 'package:eportal/repository/helper.dart';
import 'package:flutter/material.dart';
import 'package:eportal/layout/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eportal/layout/forgetpass.dart';
import 'package:eportal/component/developer_options_checker.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eportal/model/userinfo.dart';

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
        primaryColor: Colors.white,
        useMaterial3: false,
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
  bool developerMode = true;
  String _appVersion = '0';
  String appid = '';
  String appname = '';
  String appversion = '';
  String appdate = '';
  String createdby = '';
  List<VersionModel> appinfos = [];

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
    _checkDeveloperOptions();
    _getversion();
    _getAppVersion();
  }

  Future<void> _getversion() async {
    final response = await Login().getversion(appid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var appinfo in json.decode(jsondata)) {
        if (appinfo['appid'].toString() == '1') {
          setState(() {
            VersionModel appinfos = VersionModel(
              appinfo['appid'].toString(),
              appinfo['appname'].toString(),
              appinfo['appversion'].toString(),
              appinfo['appdate'].toString(),
              appinfo['createdby'].toString(),
            );
            appid = appinfos.appid;
            appname = appinfos.appname;
            appversion = appinfos.appversion;
            appdate = appinfos.appdate;
            createdby = appinfos.createdby;
          });
        }
      }
      print(appid);
      print(appname);
    }
  }

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String installedVersion = packageInfo.version;
      await _getversion();
      print('ito anf value nito: $appversion');

      setState(() {
        _appVersion = installedVersion;
      });

      if (installedVersion != appversion) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Available'),
              content: Text(
                  'A new version of the app is available. Please update to the latest version.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text('Later'),
                ),
                TextButton(
                  onPressed: () async {
                    final Uri toLaunch = Uri(
                        scheme: 'https',
                        host: 'drive.google.com',
                        path:
                            'drive/u/4/folders/1vcBLiuf2xJUH_p15TUJm8B5Y7B2je8Ap');
                    _launchInBrowser(toLaunch);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error getting version: $e");
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _checkDeveloperOptions() async {
    await DeveloperModeChecker.checkAndShowDeveloperModeDialog(context);
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
      await Future.delayed(Duration(seconds: 3));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Center(
              child: Text('No Connection!'),
            ),
            content: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                'Please check your internet connection and try again.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: 250,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 30.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      final response = await Login().login(username, password);

      if (helper.getStatusString(APIStatus.success) == response.message) {
        final jsonData = json.encode(response.result);
        for (var userinfo in json.decode(jsonData)) {
          helper.writeJsonToFile(userinfo, 'metadata.json');
        }
        _saveRememberedCredentials();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => DrawerPage()),
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
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to connect to the server. Please try again later.'),
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
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
                                  CircularProgressIndicator(
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                ],
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'App Version: $_appVersion',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
