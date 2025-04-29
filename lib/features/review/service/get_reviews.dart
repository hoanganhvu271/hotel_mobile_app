import 'dart:convert';
import 'package:hotel_app/features/review/model/review_response_dto.dart';
import 'package:http/http.dart' as http;

Future<List<ReviewResponseDto>> getReviews(List<int> reviewIds) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.50:8080/api/review/listId'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(reviewIds),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => ReviewResponseDto.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load reviews');
  }
}
