import 'dart:convert';
import 'package:hotel_app/features/order/model/booking_user_result.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/api_constants.dart';
Future<List<BookingUserResult>> fetchBookings(int userId) async {
  final response = await http.get(
    Uri.parse('${ApiConstants.baseUrl}/api/booking/user/$userId'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data
        .map((item) => BookingUserResult.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load bookings');
  }
}
