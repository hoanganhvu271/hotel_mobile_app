import 'package:hotel_app/common/local/shared_prefs/token_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../common/utils/api_constants.dart';
import '../model/user_booking.dart';

Future<UserInfo> fetchUserInfo() async {
  String? token = await TokenManager.getToken();
  if (token == null) {
    throw Exception('Token không tồn tại');
  }

  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/api/user/info'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final decodedBody = json.decode(utf8.decode(response.bodyBytes));
    return UserInfo.fromJson(decodedBody);
  } else {
    throw Exception('Failed to load user info');
  }
}
