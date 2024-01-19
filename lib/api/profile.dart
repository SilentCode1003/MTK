import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Profileinfo {
  Future<ResponceModel> getbasicinfo(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.basicinfoAPI}');
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
    Future<ResponceModel> getworkinfo(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.workinfoAPI}');
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
   Future<ResponceModel> getgovinfo(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.govinfoAPI}');
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
}