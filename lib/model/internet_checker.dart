import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> checkInternetConnection(BuildContext context) async {
  print("Checking internet connection...");
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Checking Internet Connection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Please wait...'),
          ],
        ),
      );
    },
  );

  var connectivityResult = await Connectivity().checkConnectivity();
  Navigator.of(context).pop();

  if (connectivityResult == ConnectivityResult.none) {
    print("No internet connection detected. Showing alert...");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection.'),
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
    print("Internet connection detected.");
  }
}
