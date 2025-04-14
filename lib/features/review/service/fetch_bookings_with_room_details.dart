import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotel_app/features/review/model/booking_user_result.dart';
import 'package:hotel_app/features/review/model/room_booking_detail.dart';
import 'package:hotel_app/features/review/model/booking_with_room_info.dart';

Future<List<BookingWithRoomInfo>> fetchBookingsWithRoomDetails(int userId) async {
  // Thêm header Content-Type để tránh lỗi về font chữ
  final response = await http.get(
    Uri.parse('http://172.28.160.1:8080/api/booking/user/$userId'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> bookingJsonList = jsonDecode(response.body);
    List<BookingWithRoomInfo> resultList = [];

    for (var bookingJson in bookingJsonList) {
      final booking = BookingUserResult.fromJson(bookingJson);

      final roomResponse = await http.get(
        Uri.parse('http://172.28.160.1:8080/api/room/booking/${booking.bookingId}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (roomResponse.statusCode == 200) {
        final roomJson = jsonDecode(roomResponse.body);
        final room = RoomBookingDetail.fromJson(roomJson);

        resultList.add(
          BookingWithRoomInfo(booking: booking, roomDetail: room),
        );
      }
    }
    return resultList;
  } else {
    throw Exception('Không thể tải danh sách đặt phòng');
  }
}
