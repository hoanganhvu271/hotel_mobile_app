// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// import '../model/service.dart';
// Future<void> submitBookingSearch() async {
//   final url = Uri.parse('http://172.28.160.1:8080/api/booking/search');
//   final response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode(_searchModel.toJson()),
//   );
//
//   if (response.statusCode == 200) {
//     print("Thành công: ${response.body}");
//     // Chuyển đến màn hình kết quả nếu cần
//   } else {
//     print("Lỗi khi gửi yêu cầu: ${response.statusCode}");
//   }
// }