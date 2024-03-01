import 'dart:convert';

import 'package:eportal/model/responce.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class UserNotifications {
  Future<ResponceModel> getoffenses(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.offensesAPI}');
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

  Future<ResponceModel> getannouncement(String bulletinid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.announcementAPI}');
    final response = await http.post(url, body: {
      'bulletinid': bulletinid,
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

Future<ResponceModel> postAnnouncement() async {
  final url = Uri.parse('${Config.apiUrl}${Config.postannouncementAPI}');
   final response = await http.get(url);

  final responseData = json.decode(response.body);
  final status = response.statusCode;
  final message = responseData['msg'];
  final result = responseData['data'] ?? [];
  final description = responseData['description'] ?? "";

  ResponceModel data = ResponceModel(message, status, result, description);
  return data;
}

  Future<ResponceModel> getall(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.allAPI}');
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
