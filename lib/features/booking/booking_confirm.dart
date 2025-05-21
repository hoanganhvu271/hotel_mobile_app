import 'package:flutter/material.dart';
import 'package:hotel_app/features/booking/model/booking_create_response.dart';
import 'package:hotel_app/features/booking/payment_screen.dart';
import 'package:hotel_app/features/booking/services/user_service.dart';
import 'package:intl/intl.dart';
import '../../common/utils/api_constants.dart';
import '../../common/widgets/booking_room_card.dart';
import '../../common/widgets/heading.dart';
import '../../features/booking/model/booking_room_result.dart';
import 'model/user_booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmBookingScreen extends StatefulWidget {
  final BookingRoomResult room;

  const ConfirmBookingScreen({super.key, required this.room});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  bool _useScore = false;
  late double finalPrice;

  @override
  void initState() {
    super.initState();
    finalPrice = widget.room.price;
  }

  Future<void> _createBooking() async {
    final user = await fetchUserInfo();

    final body = json.encode({
      "checkIn": formatDateTime(widget.room.checkIn),
      "checkOut": formatDateTime(widget.room.checkOut),
      "price": finalPrice,
      "userId": user.userId,
      "roomId": widget.room.roomId,
      "billId": null,
    });

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/booking'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final booking = Booking.fromJson(data);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(booking: booking),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo booking: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Stack(
                    children: [
                      const Heading(title: 'XÁC NHẬN THÔNG TIN'),
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
                BookingRoomCard(room: widget.room, showBookButton: false),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Thông tin khách hàng',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<UserInfo>(
                        future: fetchUserInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Lỗi tải thông tin người dùng: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            UserInfo user = snapshot.data!;
                            return Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildInfoRow('Khách hàng', user.fullName),
                                  _buildInfoRow('Số điện thoại', user.phone),
                                  _buildInfoRow('Điểm tích lũy', user.score.toString()),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _useScore = !_useScore;

                                        int discount = user.score;
                                        finalPrice = widget.room.price - discount;
                                        if (finalPrice < 0) finalPrice = 0;
                                      });
                                    },
                                    child: Text(_useScore
                                        ? 'Bỏ sử dụng điểm thưởng'
                                        : 'Sử dụng điểm thưởng'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Text('Không có dữ liệu người dùng');
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Thông tin đặt phòng',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildInfoRow('Ngày nhận phòng', widget.room.checkIn),
                            _buildInfoRow('Ngày trả phòng', widget.room.checkOut),
                            _buildInfoRow('Số giường', widget.room.bedNumber.toString()),
                            _buildInfoRow('Số người lớn', widget.room.adults.toString()),
                            _buildInfoRow('Số trẻ em', widget.room.children.toString()),
                            _buildInfoRow(
                              'Tổng tiền phòng',
                              NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                                  .format(widget.room.price),
                            ),
                            if (_useScore) ...[
                              _buildInfoRow(
                                'Điểm thưởng',
                                '-${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(widget.room.price - finalPrice)}',
                              ),
                              _buildInfoRow(
                                'Tổng',
                                NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                                    .format(finalPrice),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _createBooking();
                        },
                        child: const Text('Xác nhận đặt phòng'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildInfoRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF65462D),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatDateTime(String original) {
  final inputFormat = DateFormat("HH:mm dd/MM/yyyy");
  final dateTime = inputFormat.parse(original);

  final outputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  return outputFormat.format(dateTime);
}
