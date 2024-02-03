import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> checkInternetConnection(BuildContext context) async {
  
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Connection!'),
          content: Text(
            'Please check your internet connection and try again.',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
  }
}
