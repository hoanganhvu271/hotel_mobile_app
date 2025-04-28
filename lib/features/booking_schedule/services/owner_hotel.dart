import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_owner_hotel.dart';

class UserService {
  static const String apiUrl = 'http://172.28.160.1:8080/api/hotel-owner/user';
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(responseBody);
      return jsonList.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
