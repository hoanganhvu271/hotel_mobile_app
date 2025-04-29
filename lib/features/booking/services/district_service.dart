import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<String>> fetchDistricts() async {
  final response = await http.get(Uri.parse('http://192.168.1.50:8080/api/hotel/districts'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return List<String>.from(data);
  } else {
    throw Exception('Failed to load cities');
  }
}
