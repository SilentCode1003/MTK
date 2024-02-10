import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class DeveloperModeChecker {
  static Future<void> checkAndShowDeveloperModeDialog(
      BuildContext context) async {
    bool developerMode = await FlutterJailbreakDetection.developerMode;
    if (developerMode) {
      // If developer mode is detected, show the dialog
      _showDeveloperModeDialog(context);
    } else {
      print('Developer options are not enabled.');
    }
  }

  static void _showDeveloperModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => WillPopScope(
        // Intercept back button press
        onWillPop: () async {
          if (Platform.isAndroid || Platform.isIOS) {
            exit(0); // Close the app
          }
          return true;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          title: Center(child: Text('Warning!'),), 
          content: Padding( padding: EdgeInsets.only(left: 50), child: Text(
              'Disable developer options to continue.'),) ,
          actions: [
            SizedBox(
              width: 250,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                ), // Adjust the value as needed
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    if (Platform.isAndroid || Platform.isIOS) {
                      exit(0); // Close the app
                    }
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
        ),
      ),
    );
  }
}
