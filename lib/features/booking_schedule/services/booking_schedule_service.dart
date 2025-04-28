import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/booking_schedule_models.dart';

class BookingScheduleService {
  final String _baseUrl = "http://172.28.160.1:8080/api";

  Future<List<BookingDetail>> fetchBookingsByOwner(int ownerUserId) async {
    final url = Uri.parse('$_baseUrl/booking/owner/$ownerUserId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        List<BookingDetail> bookings = body
            .map((dynamic item) {
          try {
            return BookingDetail.fromJson(item);
          } catch(e) {
            print("Error parsing booking item: $item, Error: $e");
            return null;
          }
        })
            .where((booking) => booking != null)
            .cast<BookingDetail>()
            .toList();
        return bookings;
      } else {
        throw Exception('Failed to load bookings (Status code: ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Failed to connect to the server. Please check your network connection.');
    }
  }
}