import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Status {
  Future<ResponceModel> getstatus(String employeeid, String attendancedate) async {
    final url = Uri.parse('${Config.apiUrl}${Config.todaystatusAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'attendancedate' : attendancedate,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];

    print(result);

    ResponceModel data = ResponceModel(message, status, result);
    return data;
  }
}