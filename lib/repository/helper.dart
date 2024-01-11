import 'dart:convert';

import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

enum APIStatus { success, error }
enum Logtype {clockin, clockout}

class Helper {
  String GetCurrentDatetime() {
    DateTime currentDateTime = DateTime.now();
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(currentDateTime);
    return formattedDateTime;
  }

  Future<Map<String, dynamic>> readJsonToFile(String filePath) async {
    // String jsonString = File(filePath).readAsStringSync();
    String jsonString = await rootBundle.loadString(filePath);
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    // print('Loaded JSON data: $jsonData');
    return jsonData;
  }

  Future<String> readFileContent(String filePath) async {
    try {
      File file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }

  String formatAsCurrency(double value) {
    return toCurrencyString(value.toString());
  }

  Future<void> deleteFile(String filepath) async {
    try {
      File file = File(filepath);

      if (await file.exists()) {
        await file.delete();
      } else {
        print('File not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void writeJsonToFile(Map<String, dynamic> jsnonData, String filePath) {
    try {
      String assetPath = 'assets/$filePath';
      File file = File(assetPath);
      file.writeAsStringSync(jsonEncode({}));

      String jsonString = jsonEncode(jsnonData);

      file.writeAsStringSync(jsonString);

      print('JSON data written to file: $filePath');
    } catch (e) {
      print(e);
    }
  }

  String getStatusString(APIStatus status) {
    switch (status) {
      case APIStatus.success:
        return 'success';
      case APIStatus.error:
        return 'error';
      default:
        return "";
    }
  }

  String getLogtype(Logtype type) {
    switch (type) {
      case Logtype.clockin:
        return 'ClockIn';
      case Logtype.clockout:
        return 'ClockOut';
      default:
        return "";
    }
  }
}
