import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/booking/bill_booking_screen.dart';
import 'package:hotel_app/features/booking/model/booking_create_response.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/utils/api_constants.dart';
import '../../common/widgets/heading.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _remainingSeconds = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
    checkPaid();
  }

  void startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String getStatusDisplayName(String status) {
    switch (status) {
      case 'PENDING':
        return 'Chờ xác nhận';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Future<void> checkPaid() async {
    const duration = Duration(minutes: 1);
    const delayBetweenRequests = Duration(seconds: 2);
    final deadline = DateTime.now().add(duration);

    try {
      while (DateTime.now().isBefore(deadline)) {
        final response = await http.get(Uri.parse(
          "https://script.google.com/macros/s/AKfycbyYhFH3QLQdam7d84f0Qy5rxBSguA4fZfD2bauX2PGrZKXzi8dgb97Dj2M6gzT35KV5/exec",
        ));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          final moTaValues = data['data']
              .map<String>((item) => item['Mô tả']?.toString() ?? '')
              .toList();

          final priceValues = data['data']
              .map<int>((item) {
            final value = item['Giá trị'];
            if (value is int) return value;
            if (value is String && value.isNotEmpty) return int.tryParse(value) ?? 0;
            return 0;
          })
              .toList();

          String qrContent = 'Booking${widget.booking.bookingId}BBB';

          for (int i = 0; i < moTaValues.length; i++) {
            final value = moTaValues[i];
            final priceCourse = priceValues[i];

            if (priceCourse == widget.booking.price && value.contains(qrContent)) {
              _countdownTimer?.cancel();
              await http.patch(
                Uri.parse("${ApiConstants.baseUrl}/api/bill/${widget.booking.billId}/status?paidStatus=true"),
              );

              await http.put(
                Uri.parse("${ApiConstants.baseUrl}/api/booking/${widget.booking.bookingId}/status?status=CONFIRMED"),
              );

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Thanh toán thành công'),
                  content: const Text('Cảm ơn bạn đã thanh toán.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillBookingScreen(
                              bookingId: widget.booking.bookingId,
                              billId: widget.booking.billId ?? 0,
                            ),
                          ),
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );

              return;
            }
          }
        }

        await Future.delayed(delayBetweenRequests);
      }

      _countdownTimer?.cancel();
      await http.delete(
        Uri.parse("${ApiConstants.baseUrl}/api/booking/${widget.booking.bookingId}"),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Thanh toán thất bại'),
          content: const Text('Không nhận được thanh toán. Đặt phòng đã bị huỷ.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      _countdownTimer?.cancel();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi'),
          content: Text('Lỗi: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String qrContent = 'Booking${widget.booking.bookingId}BBB';
    String qrImageUrl =
        'https://img.vietqr.io/image/MB-9996905072003-compact2.png?amount=${widget.booking.price}&addInfo=$qrContent';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(0, -25),
              child: Stack(
                children: [
                  const Heading(title: 'THANH TOÁN'),
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
            const SizedBox(height: 10),

            Text(
              'Thời gian còn lại: ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Container(
                  width: 280,
                  height: 260,
                  child: Image.network(
                    qrImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildInfoRow('Mã đặt phòng', 'Booking${widget.booking.bookingId}BBB'),
                  _buildInfoRow('Tổng tiền', NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(widget.booking.price)),
                  _buildInfoRow('Trạng thái', getStatusDisplayName(widget.booking.status)),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => BillBookingScreen(
            //             bookingId: widget.booking.bookingId,
            //             billId: widget.booking.billId ?? 0,
            //           ),
            //         ),
            //       );
            //     },
            //     child: const Text('Xem Hóa Đơn'),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,  // Use backgroundColor instead of primary
            //       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
            //       textStyle: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),


            ElevatedButton(
              onPressed: () async {
                try {
                  final responseBill = await http.patch(
                    Uri.parse("${ApiConstants.baseUrl}/api/bill/${widget.booking.billId}/status?paidStatus=true"),
                  );
                  if (responseBill.statusCode == 200) {
                    final responseBooking = await http.put(
                      Uri.parse("${ApiConstants.baseUrl}/api/booking/${widget.booking.bookingId}/status?status=CONFIRMED"),
                    );
                    if (responseBooking.statusCode == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillBookingScreen(
                            bookingId: widget.booking.bookingId,
                            billId: widget.booking.billId ?? 0,
                          ),
                        ),
                      );
                    } else {
                      throw Exception("Không thể xác nhận đặt phòng.");
                    }
                  } else {
                    throw Exception("Không thể cập nhật trạng thái thanh toán.");
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Lỗi'),
                      content: Text('Lỗi: $e'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Xem Hóa Đơn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )







          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 162,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 114,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
