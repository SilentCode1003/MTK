import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class DeveloperModeChecker {
  static Future<void> checkAndShowDeveloperModeDialog(
      BuildContext context) async {
    bool developerMode = await FlutterJailbreakDetection.developerMode;
    if (developerMode) {
      _showDeveloperModeDialog(context);
    } else {
      print('Developer options are not enabled.');
    }
  }

  static void _showDeveloperModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async {
          if (Platform.isAndroid || Platform.isIOS) {
            exit(0);
          }
          return true;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0),
          ),
          title: const Center(
            child: Text('Warning!'),
          ),
          content: const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text('Disable developer options to continue.'),
          ),
          actions: [
            SizedBox(
              width: 250,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                ), 
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    if (Platform.isAndroid || Platform.isIOS) {
                      exit(0);
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
