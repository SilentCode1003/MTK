import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Leave {
  Future<ResponceModel> getleave(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.leaveAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];

    print(result);

    ResponceModel data = ResponceModel(message, status, result);
    return data;
  }

    Future<ResponceModel> request(String employeeid, String startdate, String enddate, String leavetype, String reason) async {
    final url = Uri.parse('${Config.apiUrl}${Config.requestleaveAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'startdate': startdate,
      'enddate': enddate,
      'leavetype': leavetype,
      'reason': reason,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];

    ResponceModel data = ResponceModel(message, status, result);
    return data;
  }
}
