import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/review/model/booking_with_room_info.dart';
import 'package:hotel_app/features/review/service/fetch_bookings_with_room_details.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/review/model/booking_with_room_info.dart';
import 'package:hotel_app/features/review/service/fetch_bookings_with_room_details.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingListUserScreen extends StatefulWidget {
  const BookingListUserScreen({super.key});

  @override
  _BookingListUserScreenState createState() => _BookingListUserScreenState();
}

class _BookingListUserScreenState extends State<BookingListUserScreen> {
  late Future<List<BookingWithRoomInfo>> bookings;

  @override
  void initState() {
    super.initState();
    bookings = fetchBookingsWithRoomDetails(1);
  }

  Future<void> submitReview(String content, int rating, int bookingId) async {
    final url = Uri.parse('http://172.28.160.1:8080/api/review');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'content': content,
        'rating': rating,
        'bookingId': bookingId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đánh giá đã được gửi!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Có lỗi xảy ra khi gửi đánh giá.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Transform.translate(
          offset: const Offset(0, 0),
          child: Stack(
            children: [
              const Heading(title: 'ĐẶT PHÒNG'),
              Positioned(
                left: 20,
                top: 22,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<BookingWithRoomInfo>>(
          future: bookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Có lỗi xảy ra'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Chưa có đặt phòng nào'));
            } else {
              final bookingList = snapshot.data!;
              return ListView.builder(
                itemCount: bookingList.length,
                itemBuilder: (context, index) {
                  final item = bookingList[index];
                  final booking = item.booking;
                  final room = item.roomDetail;

                  DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
                  String checkInDate = dateFormat.format(DateTime.parse(booking.checkIn));
                  String checkOutDate = dateFormat.format(DateTime.parse(booking.checkOut));
                  String createdAtDate = dateFormat.format(DateTime.parse(booking.createdAt));

                  Color statusColor;
                  String statusText;
                  switch (booking.status) {
                    case 'PENDING':
                      statusColor = Colors.grey;
                      statusText = 'Đang chờ';
                      break;
                    case 'CONFIRMED':
                      statusColor = Colors.green;
                      statusText = 'Đã xác nhận';
                      break;
                    case 'CANCELLED':
                      statusColor = Colors.red;
                      statusText = 'Bị hủy';
                      break;
                    default:
                      statusColor = Colors.grey;
                      statusText = 'Không xác định';
                  }

                  final priceFormatted = NumberFormat("#,###", "vi_VN").format(booking.price);

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'http://172.28.160.1:8080/api/files/${room.roomImg}',
                                    width: 110,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 70,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Text(
                                      statusText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#Booking${booking.bookingId}',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${room.roomName} - ${room.hotelName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF65462D),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text('Địa chỉ: ${room.specificAddress}', style: const TextStyle(fontSize: 12)),
                                Text('Ngày nhận: $checkInDate', style: const TextStyle(fontSize: 12)),
                                Text('Ngày trả: $checkOutDate', style: const TextStyle(fontSize: 12)),
                                Text('Ngày tạo: $createdAtDate', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (booking.status == 'CONFIRMED')
                                  Column(
                                    children: [
                                      const SizedBox(height: 30),

                                      GestureDetector(
                                        onTap: () {
                                          String content = '';
                                          TextEditingController reviewController = TextEditingController();
                                          int localSelectedStars = 0;

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder( // Dùng StatefulBuilder để setState trong dialog
                                                builder: (context, setState) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Container(
                                                      height: 350,
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(width: 1, color: const Color(0xFFB3B3B3)),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            'Đánh giá phòng',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xFF65462D),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          const Text('Đánh giá: 1-5 sao', style: TextStyle(fontSize: 14)),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: List.generate(5, (index) {
                                                              return IconButton(
                                                                icon: Icon(
                                                                  index < localSelectedStars ? Icons.star : Icons.star_border,
                                                                  color: Colors.yellow,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    localSelectedStars = index + 1;
                                                                  });
                                                                },
                                                              );
                                                            }),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          const Text('Nhận xét:', style: TextStyle(fontSize: 14)),
                                                          TextField(
                                                            controller: reviewController,
                                                            decoration: const InputDecoration(
                                                              hintText: 'Nhập nhận xét của bạn...',
                                                              border: OutlineInputBorder(),
                                                            ),
                                                            maxLines: 3,
                                                          ),
                                                          const SizedBox(height: 16),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Đóng'),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.grey,
                                                                  foregroundColor: Colors.white,
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  content = reviewController.text;
                                                                  submitReview(content, localSelectedStars, booking.bookingId);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Gửi'),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: const Color(0xFF65462D),
                                                                  foregroundColor: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFA68367),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: const Text(
                                            'Đánh giá',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (booking.status != 'CONFIRMED')
                                  const SizedBox(height: 50),
                                Text(
                                  '$priceFormatted VND',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF65462D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
