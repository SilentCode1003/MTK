import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();

}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isLoading = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordObscuredold = true;
  bool _isPasswordObscurednew = true;
  bool _isPasswordObscuredconfirm = true;

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
                obscureText: _isPasswordObscuredconfirm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Enter confirm password',
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
                onPressed: () {},
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
    );
  }

  void main() {
    runApp(MaterialApp(
      home: ChangePasswordScreen(),
    ));
  }
}
