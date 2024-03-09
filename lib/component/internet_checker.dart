import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> checkInternetConnection(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the value as needed
            ),
          title: const Center(child: Text('No Connection!'),),
          content: const Padding( padding: EdgeInsets.only(left: 50), 
          child: Text('Please check your internet connection and try again.',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),),
          actions: <Widget>[
            SizedBox(
              width: 250,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 40.0,
                ), // Adjust the value as needed
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
  } else {}
}
