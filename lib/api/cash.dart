import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Cash {
  Future<ResponceModel> getcash(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.cashAPI}');
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
    Future<ResponceModel> request(String employeeid, String amount, String purpose) async {
    final url = Uri.parse('${Config.apiUrl}${Config.requestashAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'amount': amount,
      'purpose': purpose,

    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}