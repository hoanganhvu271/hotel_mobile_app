import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/booking/model/bill_response_dto.dart';
import 'package:hotel_app/features/booking/model/booking_response_dto.dart';
import 'package:hotel_app/features/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../common/utils/api_constants.dart';

class BillBookingScreen extends StatefulWidget {
  final int bookingId;
  final int billId;

  const BillBookingScreen({super.key, required this.bookingId, required this.billId});

  @override
  _BillBookingScreenState createState() => _BillBookingScreenState();
}

class _BillBookingScreenState extends State<BillBookingScreen> {
  late Future<BookingResponseDto> bookingData;
  late Future<BillResponseDto> billData;


  @override
  void initState() {
    super.initState();
    bookingData = fetchBooking(widget.bookingId);
    billData = fetchBill(widget.billId);
  }

  Future<BookingResponseDto> fetchBooking(int id) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/booking/$id'));

    if (response.statusCode == 200) {
      return BookingResponseDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load booking');
    }
  }

  Future<BillResponseDto> fetchBill(int id) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/bill/$id'));

    if (response.statusCode == 200) {
      return BillResponseDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load bill');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'XÁC NHẬN HÓA ĐƠN'),
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
          const SizedBox(height: 10),

          FutureBuilder(
            future: Future.wait([bookingData, billData]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final booking = snapshot.data![0] as BookingResponseDto;
                final bill = snapshot.data![1] as BillResponseDto;

                String formattedCheckIn = DateFormat('HH:mm dd/MM/yyyy').format(booking.checkIn);
                String formattedCheckOut = DateFormat('HH:mm dd/MM/yyyy').format(booking.checkOut);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 146,
                                child: Text(
                                  'Mã hóa đơn:',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Text(
                                  '#HD${bill.billId}',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 146,
                                child: Text(
                                  'Nhận phòng:',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Text(
                                  formattedCheckIn,
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 146,
                                child: Text(
                                  'Trả phòng:',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Text(
                                  formattedCheckOut,
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 146,
                                child: Text(
                                  'Tổng tiền:',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Text(
                                  '${NumberFormat("#,###").format(bill.totalPrice)} VND',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 146,
                                child: Text(
                                  'Trạng thái thanh toán:',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Text(
                                  bill.paidStatus ? 'Đã thanh toán' : 'Chưa thanh toán',
                                  style: TextStyle(
                                    color: const Color(0xFF65462D),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                                  (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home, color: Colors.white),
                          label: const Text(
                            'Về Trang Chủ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF65462D),
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 5,
                            shadowColor: Colors.brown.shade200,
                          ),
                        ),
                      ),
                    ],





                  ),
                );
              } else {
                return const Center(child: Text('Không có dữ liệu.'));
              }
            },
          )

        ],
      ),
    );
  }
}
