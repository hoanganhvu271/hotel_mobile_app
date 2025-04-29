import 'package:hotel_app/common/local/shared_prefs/token_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user_booking.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<UserInfo> fetchUserInfo() async {
  String? token = await TokenManager.getToken();
  if (token == null) {
    throw Exception('Token không tồn tại');
  }
  final response = await http.get(
    Uri.parse('http://192.168.1.50:8080/api/user/info'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return UserInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load user info');
  }
}
