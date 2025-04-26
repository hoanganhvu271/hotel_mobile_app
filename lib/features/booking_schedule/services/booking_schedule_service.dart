// services/booking_schedule_service.dart (Example file name)
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/booking_schedule_models.dart';

class BookingScheduleService {
  // Replace with your actual API base URL
  final String _baseUrl = "http://172.28.160.1:8080/api";

  Future<List<BookingDetail>> fetchBookingsByOwner(int ownerUserId) async {
    // TODO: Replace with your actual authentication/token handling if needed
    final url = Uri.parse('$_baseUrl/booking/owner/$ownerUserId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add Authorization header if required:
          // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        },
      ).timeout(const Duration(seconds: 15)); // Add timeout

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes)); // Handle UTF8
        List<BookingDetail> bookings = body
            .map((dynamic item) {
          try {
            return BookingDetail.fromJson(item);
          } catch(e) {
            print("Error parsing booking item: $item, Error: $e");
            return null; // Skip items that fail parsing
          }
        })
            .where((booking) => booking != null) // Filter out nulls caused by errors
            .cast<BookingDetail>() // Cast back to the correct type
            .toList();
        return bookings;
      } else {
        // Handle non-200 responses (e.g., 404, 500)
        throw Exception('Failed to load bookings (Status code: ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Failed to connect to the server. Please check your network connection.');
    }
  }
}