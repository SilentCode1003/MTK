import 'dart:convert';
import 'package:eportal/model/responce.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class OverTime{
  Future<ResponceModel> getot(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.otAPI}');
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
}