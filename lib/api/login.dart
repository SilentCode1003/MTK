import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Login {
  Future<ResponceModel> login(String username, String password) async {
    final url = Uri.parse('${Config.apiUrl}${Config.loginAPI}');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];

    ResponceModel data = ResponceModel(message, status, result);
    return data;
  }
}
