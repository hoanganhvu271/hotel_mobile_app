// import 'package:flutter/material.dart';
// import 'package:hotel_app/features/booking/model/booking_create_response.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../common/widgets/heading.dart';
//
// class PaymentScreen extends StatefulWidget {
//   final Booking booking;
//
//   const PaymentScreen({super.key, required this.booking});
//
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   bool isSuccess = false; // Biến để kiểm tra trạng thái thanh toán
//   String statusMessage = ''; // Thông báo trạng thái thanh toán
//
//   @override
//   void initState() {
//     super.initState();
//     checkPaid(); // Gọi hàm kiểm tra thanh toán khi màn hình được khởi tạo
//   }
//
//   Future<void> checkPaid() async {
//     const duration = Duration(minutes: 2);
//     const delayBetweenRequests = Duration(seconds: 2);
//     final deadline = DateTime.now().add(duration);
//
//     try {
//       while (DateTime.now().isBefore(deadline)) {
//         final response = await http.get(Uri.parse(
//           "https://script.google.com/macros/s/AKfycbyYhFH3QLQdam7d84f0Qy5rxBSguA4fZfD2bauX2PGrZKXzi8dgb97Dj2M6gzT35KV5/exec",
//         ));
//
//         print('Response status: ${response.statusCode}');
//         print('Response body: ${response.body}');
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//
//           final moTaValues = data['data']
//               .map<String>((item) => item['Mô tả']?.toString() ?? '')
//               .toList();
//
//           final priceValues = data['data']
//               .map<int>((item) {
//             final value = item['Giá trị'];
//             if (value is int) return value;
//             if (value is String && value.isNotEmpty) return int.tryParse(value) ?? 0;
//             return 0;
//           })
//               .toList();
//
//           print('moTaValues: $moTaValues');
//           print('priceValues: $priceValues');
//
//           String qrContent = 'Booking${widget.booking.bookingId}BBB';
//           print('qrContent: $qrContent');
//
//           for (int i = 0; i < moTaValues.length; i++) {
//             final value = moTaValues[i];
//             final priceCourse = priceValues[i];
//
//             print('Checking value: $value with qrContent: $qrContent');
//             print('Comparing priceCourse: $priceCourse with widget.booking.price: ${widget.booking.price}');
//
//             if (priceCourse == widget.booking.price && value.contains(qrContent)) {
//               setState(() {
//                 statusMessage = "Thanh toán thành công";
//                 isSuccess = true;
//               });
//               return;
//             }
//           }
//         } else {
//           print('Lỗi kết nối. Thử lại sau.');
//         }
//
//         await Future.delayed(delayBetweenRequests);
//       }
//
//       // Nếu hết 2 phút mà không tìm thấy giao dịch hợp lệ
//       setState(() {
//         statusMessage = "Thanh toán không thành công";
//         isSuccess = false;
//       });
//     } catch (e) {
//       setState(() {
//         statusMessage = "Lỗi: $e";
//       });
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Tạo nội dung QR (mã booking và số tiền)
//     String qrContent = 'Booking${widget.booking.bookingId}BBB';
//
//     // URL của ảnh QR
//     String qrImageUrl = 'https://img.vietqr.io/image/MB-9996905072003-compact2.png?amount=${widget.booking.price}&addInfo=$qrContent';
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Transform.translate(
//               offset: const Offset(0, -25),
//               child: Stack(
//                 children: [
//                   const Heading(title: 'THANH TOÁN'),
//                   Positioned(
//                     left: 20,
//                     top: 22,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Center(
//                 child: Container(
//                   width: 280,
//                   height: 260,
//                   child: Image.network(
//                     qrImageUrl,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 60.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   _buildInfoRow('Mã đặt phòng', 'Booking${widget.booking.bookingId}BBB'),
//                   _buildInfoRow('Tổng tiền', NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(widget.booking.price)),
//                   _buildInfoRow('Trạng thái', widget.booking.status),
//                 ],
//               ),
//             ),
//
//             // Hiển thị thông báo thanh toán
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Text(
//                 statusMessage,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: isSuccess ? Colors.green : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       width: double.infinity,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,  // Canh trái cho các item trong Row
//         children: [
//           SizedBox(
//             width: 162, // Cố định kích thước cho phần tiêu đề
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 16,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 114, // Cố định kích thước cho phần giá trị
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 16,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w700,
//               ),
//               textAlign: TextAlign.right,  // Canh phải cho phần giá trị
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:hotel_app/features/booking/model/booking_create_response.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../common/widgets/heading.dart';
//
// class PaymentScreen extends StatefulWidget {
//   final Booking booking;
//
//   const PaymentScreen({super.key, required this.booking});
//
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   bool isSuccess = false;
//   String statusMessage = '';
//   int _remainingSeconds = 120;
//   Timer? _countdownTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     startCountdown();
//     checkPaid();
//   }
//
//   void startCountdown() {
//     _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         setState(() {
//           _remainingSeconds--;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   Future<void> checkPaid() async {
//     const duration = Duration(minutes: 2);
//     const delayBetweenRequests = Duration(seconds: 2);
//     final deadline = DateTime.now().add(duration);
//
//     try {
//       while (DateTime.now().isBefore(deadline)) {
//         final response = await http.get(Uri.parse(
//           "https://script.google.com/macros/s/AKfycbyYhFH3QLQdam7d84f0Qy5rxBSguA4fZfD2bauX2PGrZKXzi8dgb97Dj2M6gzT35KV5/exec",
//         ));
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//
//           final moTaValues = data['data']
//               .map<String>((item) => item['Mô tả']?.toString() ?? '')
//               .toList();
//
//           final priceValues = data['data']
//               .map<int>((item) {
//             final value = item['Giá trị'];
//             if (value is int) return value;
//             if (value is String && value.isNotEmpty) return int.tryParse(value) ?? 0;
//             return 0;
//           })
//               .toList();
//
//           String qrContent = 'Booking${widget.booking.bookingId}BBB';
//
//           for (int i = 0; i < moTaValues.length; i++) {
//             final value = moTaValues[i];
//             final priceCourse = priceValues[i];
//
//             if (priceCourse == widget.booking.price && value.contains(qrContent)) {
//               _countdownTimer?.cancel();
//               setState(() {
//                 statusMessage = "Thanh toán thành công";
//                 isSuccess = true;
//               });
//               return;
//             }
//           }
//         }
//
//         await Future.delayed(delayBetweenRequests);
//       }
//
//       _countdownTimer?.cancel();
//       setState(() {
//         statusMessage = "Thanh toán không thành công";
//         isSuccess = false;
//       });
//     } catch (e) {
//       _countdownTimer?.cancel();
//       setState(() {
//         statusMessage = "Lỗi: $e";
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String qrContent = 'Booking${widget.booking.bookingId}BBB';
//     String qrImageUrl =
//         'https://img.vietqr.io/image/MB-9996905072003-compact2.png?amount=${widget.booking.price}&addInfo=$qrContent';
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Transform.translate(
//               offset: const Offset(0, -25),
//               child: Stack(
//                 children: [
//                   const Heading(title: 'THANH TOÁN'),
//                   Positioned(
//                     left: 20,
//                     top: 22,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Thời gian đếm ngược
//             Text(
//               'Thời gian còn lại: ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Center(
//                 child: Container(
//                   width: 280,
//                   height: 260,
//                   child: Image.network(
//                     qrImageUrl,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 60.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   _buildInfoRow('Mã đặt phòng', 'Booking${widget.booking.bookingId}BBB'),
//                   _buildInfoRow('Tổng tiền', NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(widget.booking.price)),
//                   _buildInfoRow('Trạng thái', widget.booking.status),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Text(
//                 statusMessage,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: isSuccess ? Colors.green : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       width: double.infinity,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 162,
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 16,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 114,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 16,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w700,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotel_app/features/booking/model/booking_create_response.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/widgets/heading.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _remainingSeconds = 120;
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

  Future<void> checkPaid() async {
    const duration = Duration(minutes: 2);
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
                        Navigator.pop(context);
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

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Thanh toán thất bại'),
          content: const Text('Không nhận được thanh toán. Vui lòng thử lại sau.'),
          actions: [
            TextButton(
              onPressed: () {
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

            // Thời gian đếm ngược
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
                  _buildInfoRow('Trạng thái', widget.booking.status),
                ],
              ),
            ),
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
