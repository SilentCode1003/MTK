import 'dart:convert';

import 'package:eportal/model/responce.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class UserNotifications {
  Future<ResponceModel> getnotification(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.NotificationAPI}');
    final response = await http.post(url, body: {'employeeid': employeeid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> getnotificationbadges(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.countunreadnotifAPI}');
    final response = await http.post(url, body: {'employeeid': employeeid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> reloadnotification(String employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.reloadnotifAPI}');
    final response = await http.post(url, body: {'employeeid': employeeid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);

    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> readnotication(String notificationid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.readnotifAPI}');
    final response =
        await http.post(url, body: {'notificationId': notificationid});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final message = responseData['msg'];
    final result = responseData['data'] ?? [];
    final description = responseData['description'] ?? "";

    print(result);
    ResponceModel data = ResponceModel(message, status, result, description);
    return data;
  }

  Future<ResponceModel> deletenotication(String notificationid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.deletenotifAPI}');
    final response =
        await http.post(url, body: {'notificationId': notificationid});

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
