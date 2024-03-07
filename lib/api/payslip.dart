import 'dart:convert';
import 'package:eportal/model/responce.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class Payroll{
  Future<ResponceModel> getdate(String gp_payrolldate) async {
    final url = Uri.parse('${Config.apiUrl}${Config.payrolldateAPI}');
    final response = await http.post(url, body: {
      'gp_payrolldate': gp_payrolldate,
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
    Future<ResponceModel> getpayslip(String employeeid, String payrolldate) async {
    final url = Uri.parse('${Config.apiUrl}${Config.payslipdetailsAPI}');
    final response = await http.post(url, body: {
      'employeeid': employeeid,
      'payrolldate': payrolldate,
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