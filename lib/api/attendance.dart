import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class UserAttendance {
  Future<ResponceModel> getattendance(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.attendanceAPi}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> filterattendance(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.filterattendanceAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> clockin(
      String employeeid, String latitude, String longitude, String geofenceid, String devicein) async {
    final url = Uri.parse('${Config.apiUrl}${Config.clockinAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'latitude': latitude,
      'longitude': longitude,
      'geofenceid': geofenceid,
      'devicein': devicein, 
    });

    print(response.body);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['status'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> clockout(
      String employeeid, String latitude, String longitude, String geofenceid, String deviceout) async {
    final url = Uri.parse('${Config.apiUrl}${Config.clockoutAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'latitude': latitude,
      'longitude': longitude,
      'geofenceid': geofenceid,   
      'deviceout': deviceout,  
    });

    print(response.body);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['status'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> getlateslog(String employeeid) async {
    print(employeeid);
    final url = Uri.parse('${Config.apiUrl}${Config.getlateslogAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    print(response.body);

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['message'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
