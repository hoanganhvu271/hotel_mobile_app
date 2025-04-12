import 'package:hotel_app/common/local/shared_prefs/token_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user_booking.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<UserInfo> fetchUserInfo() async {
  // Lấy token từ SharedPreferences
  String? token = await TokenManager.getToken();

  // Kiểm tra xem token có tồn tại hay không
  if (token == null) {
    throw Exception('Token không tồn tại');
  }

  // Thực hiện yêu cầu HTTP với token trong header
  final response = await http.get(
    Uri.parse('http://172.28.160.1:8080/api/user/info'),
    headers: {
      'Authorization': 'Bearer $token',  // Thêm token vào header
    },
  );

  if (response.statusCode == 200) {
    return UserInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load user info');
  }
}
