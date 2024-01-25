import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eportal/main.dart';
import 'package:eportal/api/changepass.dart';
import 'package:eportal/repository/helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String employeeid;

  const ChangePasswordScreen({super.key, required this.employeeid});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String employeeid = '';
  bool isLoading = false;

  Helper helper = Helper();

  late TextEditingController OldPasswordController;
  late TextEditingController NewPasswordController;
  late TextEditingController ConfirmPasswordController;

  bool _isPasswordObscuredold = true;
  bool _isPasswordObscurednew = true;
  bool _isPasswordObscuredconfirm = true;

  String _passwordError = ''; // Store the password validation error

  FocusNode confirmPasswordFocusNode = FocusNode();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscuredold = !_isPasswordObscuredold;
    });
  }

  void _togglenewPasswordVisibility() {
    setState(() {
      _isPasswordObscurednew = !_isPasswordObscurednew;
    });
  }

  void _toggleconfirmPasswordVisibility() {
    setState(() {
      _isPasswordObscuredconfirm = !_isPasswordObscuredconfirm;
    });
  }

  String _validatePassword(String newPassword, String confirmPassword) {
    if (newPassword != confirmPassword) {
      return 'Passwords do not match';
    }
    return '';
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _changepass() async {
    String currentPass = oldPasswordController.text;
    String newPass = newPasswordController.text;
    String confirmPass = confirmPasswordController.text;

    print('$currentPass $newPass $confirmPass');

    if (newPass != confirmPass) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('New and confirm passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Ask for confirmation
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to change your password?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == null || !confirm) {
      return;
    }

    try {
      final response = await ChangePassword().changepass(
        widget.employeeid,
        currentPass,
        newPass,
        confirmPass,
      );
      print(response.message);

      if (response.status == 200) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Success'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.popUntil(ctx, (route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()), // Replace MyApp with your main.dart class
            );
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
 else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(response.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred'),
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
  void initState() {
    super.initState();
    OldPasswordController = TextEditingController();
    NewPasswordController = TextEditingController();
    ConfirmPasswordController = TextEditingController();
    confirmPasswordFocusNode.addListener(() {
      if (!confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _passwordError = _validatePassword(
            newPasswordController.text,
            confirmPasswordController.text,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 215, 36, 24),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/changepass.png'),
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
                  controller: oldPasswordController,
                  obscureText: _isPasswordObscuredold,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Old Password',
                    hintText: 'Enter secure old password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscuredold
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15,
                  bottom: 15,
                ),
                child: TextField(
                  controller: newPasswordController,
                  obscureText: _isPasswordObscurednew,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscurednew
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _togglenewPasswordVisibility();
                      },
                    ),
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
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  obscureText: _isPasswordObscuredconfirm,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter confirm password',
                    errorText: _passwordError, // Display the password error
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscuredconfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _toggleconfirmPasswordVisibility();
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
                    _changepass();
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
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: ChangePasswordScreen(
        employeeid: employeeid,
      ),
    ));
  }
}
