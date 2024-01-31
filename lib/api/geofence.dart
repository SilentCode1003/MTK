import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class Geofence {
  Future<ResponceModel> getfence(String department) async {
    final url = Uri.parse('${Config.apiUrl}${Config.geofenceAPI}');
    final response = await http.post(url, body: {
      'department': department,
    });

    print(response.body);
    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }
}
