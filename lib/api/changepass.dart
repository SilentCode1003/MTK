import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class ChangePassword {
  Future<ResponceModel> changepass(String employeeid, String currentPass, String newPass, String confirmPass) async {
    final url = Uri.parse('${Config.apiUrl}${Config.changepassAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'currentPass': currentPass,
      'newPass': newPass,
      'confirmPass': confirmPass,
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
