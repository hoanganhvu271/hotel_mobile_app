import 'dart:convert';
import 'package:hotel_app/common/utils/api_constants.dart';
import 'package:hotel_app/features/admin_system/model/admin_data.dart';
import 'package:hotel_app/features/admin_system/model/daily_revenue.dart';
import 'package:http/http.dart' as http;

class AdminService {
  static const String _baseUrl = '${ApiConstants.baseUrl}/api/admin/';

  Future<List<DailyRevenue>> fetchMonthlyRevenue() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/admin/revenue/monthly'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return jsonMap.entries
          .map((entry) => DailyRevenue.fromJsonEntry(entry))
          .toList();
    } else {
      throw Exception('Failed to load monthly revenue');
    }
  }

  Future<AdminData> fetchAdminData() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return AdminData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load admin data');
    }
  }
}


// admin_service.dart

// import 'dart:math';
// import 'package:hotel_app/features/admin_system/model/admin_data.dart';
// import 'package:hotel_app/features/admin_system/model/daily_revenue.dart';
//
// class AdminService {
//   Future<AdminData> fetchAdminData() async {
//     await Future.delayed(const Duration(seconds: 1));
//     return AdminData(
//       totalHotels: 25,
//       totalUsers: 1000,
//       totalBookings: 340,
//     );
//   }
//
//   Future<List<DailyRevenue>> fetchMonthlyRevenue() async {
//     await Future.delayed(const Duration(seconds: 1));
//     final now = DateTime.now();
//     final List<DailyRevenue> data = List.generate(30, (index) {
//       final day = now.subtract(Duration(days: 29 - index));
//       final date = '${day.year}-${_twoDigits(day.month)}-${_twoDigits(day.day)}';
//       final revenue = Random().nextInt(1000000) + 500000;
//       return DailyRevenue(date: date, revenue: revenue.toDouble());
//     });
//     return data;
//   }
//
//   String _twoDigits(int n) => n.toString().padLeft(2, '0');
// }
