// import 'package:flutter/material.dart';
// import 'package:hotel_app/features/home/widget/hotel_card.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:hotel_app/common/widgets/home_booking_btn.dart';
// import 'package:hotel_app/common/widgets/top_app_bar_widget.dart';
// import 'package:hotel_app/features/booking/booking_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> rooms = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTopRatedRooms();
//   }
//
//   // Hàm gọi API để lấy dữ liệu phòng
//   Future<void> fetchTopRatedRooms() async {
//     final response = await http.get(Uri.parse('http://172.28.160.1:8080/api/room/top-rated'));
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         rooms = data;
//         print(rooms);
//         isLoading = false;
//       });
//     } else {
//       print("Error: ${response.statusCode}");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const TopAppBarWidget(),
//             Transform.translate(
//               offset: const Offset(0, -95),
//               child: const BookingBtn(
//                 label: 'ĐẶT PHÒNG',
//                 screen: BookingScreen(),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Khách sạn nổi bật",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   if (isLoading)
//                     const Center(child: CircularProgressIndicator()),
//                   if (!isLoading && rooms.isNotEmpty)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: rooms.map((room) {
//                           final imageUrl = 'http://172.28.160.1:8080/api/files/${room['roomImg']}';
//                           final city = room['hotelDto']['address']['city'];
//                           final district = room['hotelDto']['address']['district'];
//
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                             child: HotelCard(
//                               name: room['roomName'],
//                               imageUrl: imageUrl,
//                               city: city,         // Truyền city vào
//                               district: district, // Truyền district vào
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   // Nếu không có dữ liệu phòng
//                   if (!isLoading && rooms.isEmpty)
//                     const Center(child: Text('Không có phòng nào để hiển thị')),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hotel_app/features/home/widget/hotel_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hotel_app/common/widgets/home_booking_btn.dart';
import 'package:hotel_app/common/widgets/top_app_bar_widget.dart';
import 'package:hotel_app/features/booking/booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopRatedRooms();
  }

  // Hàm gọi API để lấy dữ liệu phòng
  Future<void> fetchTopRatedRooms() async {
    final response = await http.get(Uri.parse('http://172.28.160.1:8080/api/room/top-rated'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        rooms = data;
        print(rooms);
        isLoading = false;
      });
    } else {
      print("Error: ${response.statusCode}");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopAppBarWidget(),
            Transform.translate(
              offset: const Offset(0, -95),
              child: const BookingBtn(
                label: 'ĐẶT PHÒNG',
                screen: BookingScreen(),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -95), // Dịch chuyển tất cả các phần sau TopAppBar
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề "Khách sạn nổi bật" với màu nâu đậm
                    const Text(
                      "Khách sạn nổi bật",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723), // Màu nâu đậm
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (!isLoading && rooms.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: rooms.map((room) {
                            final imageUrl = 'http://172.28.160.1:8080/api/files/${room['roomImg']}';
                            final city = room['hotelDto']['address']['city'];
                            final district = room['hotelDto']['address']['district'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: HotelCard(
                                name: room['roomName'],
                                imageUrl: imageUrl,
                                city: city,
                                district: district,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (!isLoading && rooms.isEmpty)
                      const Center(child: Text('Không có phòng nào để hiển thị')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
