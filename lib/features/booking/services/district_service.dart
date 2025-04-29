import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/utils/api_constants.dart';

Future<List<String>> fetchDistricts() async {
  final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/hotel/districts'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return List<String>.from(data);
  } else {
    throw Exception('Failed to load cities');
  }
}
