import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/utils/api_constants.dart';
import '../model/room.dart';

class RoomService {
  Future<List<Room>> fetchRoomsByHotelId(int hotelId) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/room/hotel/$hotelId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((room) => Room.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }
}
