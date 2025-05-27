import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/admin_system_home.dart';
import 'package:hotel_app/features/home/widget/hotel_card.dart';
import 'package:hotel_app/features/hotel_owner/hotel_owner_system_home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hotel_app/common/widgets/home_booking_btn.dart';
import 'package:hotel_app/common/widgets/top_app_bar_widget.dart';
import 'package:hotel_app/features/booking/booking_screen.dart';

import '../../common/utils/api_constants.dart';
import '../more_user/more_user_srceen.dart';

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

  Future<void> fetchTopRatedRooms() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/room/top-rated'));

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
              offset: const Offset(0, -95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Khách sạn nổi bật",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
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
                            final imageUrl = '${ApiConstants.baseUrl}/api/files/${room['roomImg']}';
                            final city = room['hotelDto']['address']['city'];
                            final district = room['hotelDto']['address']['district'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: HotelCard(
                                id: room['roomId'],
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

            // Transform.translate(
            //   offset: const Offset(0, -95),
            //   child: const BookingBtn(
            //     label: 'More',
            //     screen: MoreUserSrceen(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
