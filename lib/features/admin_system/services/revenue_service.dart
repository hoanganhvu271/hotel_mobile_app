import 'dart:convert';
import 'package:hotel_app/features/admin_system/model/revenue_model.dart';
import 'package:http/http.dart' as http;

class RevenueService {
  Future<RevenueModel> fetchRevenueData(String startDate, String endDate) async {
    final url = Uri.parse('http://172.28.160.1:8080/api/admin/revenue/total');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'startDate': startDate,
      'endDate': endDate,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        return RevenueModel.fromJson(json.decode(decodedResponse));
      } else {
        throw Exception('Failed to load revenue data');
      }
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }
}
