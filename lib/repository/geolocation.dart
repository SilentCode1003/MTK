import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are disabled
    return Future.error('Location services are disabled.');
  }

  // Check if the app has permission to access location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Location permissions are denied
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permission still denied
      return Future.error('Location permissions are denied.');
    }
  }

  // Get the current location
  return await Geolocator.getCurrentPosition();
}

Future<String> getGeolocationName(double latitude, double longitude) async {
  String locationName = '';
  final response = await http.get(Uri.parse(
      'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude'));

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    if (kDebugMode) {
      print(responseData['display_name']);
    }

    locationName = responseData['display_name'];
    return locationName;
  } else {
    throw Exception('Failed to fetch data');
  }
}
