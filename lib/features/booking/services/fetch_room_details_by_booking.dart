import 'package:hotel_app/features/booking/model/room_response_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<RoomResponseDto> fetchRoomDetailsByBookingId(int bookingId) async {
  final response = await http.get(Uri.parse('http://172.28.160.1:8080/api/room/booking/$bookingId'));
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data != null) {
      return RoomResponseDto.fromJson(data);
    } else {
      throw Exception('Room data is null');
    }
  } else {
    throw Exception('Failed to load room details');
  }
}
