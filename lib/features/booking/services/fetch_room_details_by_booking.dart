import 'package:hotel_app/features/booking/model/room_response_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../common/utils/api_constants.dart';
Future<RoomResponseDto> fetchRoomDetailsByBookingId(int bookingId) async {
  final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/room/booking/$bookingId'));
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
