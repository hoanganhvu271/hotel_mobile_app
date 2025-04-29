

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/service.dart';

Future<List<Service>> fetchServices() async {
  final response = await http.get(Uri.parse('http://192.168.1.50:8080/api/service'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Service.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load services');
  }
}
