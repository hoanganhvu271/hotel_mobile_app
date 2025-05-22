import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/utils/api_constants.dart';
import '../model/review_response_dto.dart';

Future<List<ReviewResponseDto>> getReviews(List<int> reviewIds) async {
  final response = await http.post(
    Uri.parse('${ApiConstants.baseUrl}/api/review/listId'),
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
