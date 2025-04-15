// import 'package:flutter/material.dart';
// import 'package:hotel_app/common/widgets/heading.dart';
// import 'package:hotel_app/features/review/model/booking_with_room_info.dart';
// import 'package:hotel_app/features/review/service/fetch_bookings_with_room_details.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class BookingListUserScreen extends StatefulWidget {
//   const BookingListUserScreen({super.key});
//
//   @override
//   _BookingListUserScreenState createState() => _BookingListUserScreenState();
// }
//
// class _BookingListUserScreenState extends State<BookingListUserScreen> {
//   late Future<List<BookingWithRoomInfo>> bookings;
//
//   @override
//   void initState() {
//     super.initState();
//     bookings = fetchBookingsWithRoomDetails(1);
//   }
//
//   Future<void> submitReview(String content, int rating, int bookingId) async {
//     final url = Uri.parse('http://172.28.160.1:8080/api/review');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'content': content,
//         'rating': rating,
//         'bookingId': bookingId,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Đánh giá đã được gửi!'),
//       ));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Có lỗi xảy ra khi gửi đánh giá.'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100.0),
//         child: Transform.translate(
//           offset: const Offset(0, 0),
//           child: Stack(
//             children: [
//               const Heading(title: 'ĐẶT PHÒNG'),
//               Positioned(
//                 left: 20,
//                 top: 22,
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: FutureBuilder<List<BookingWithRoomInfo>>(
//           future: bookings,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return const Center(child: Text('Có lỗi xảy ra'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('Chưa có đặt phòng nào'));
//             } else {
//               final bookingList = snapshot.data!;
//               return ListView.builder(
//                 itemCount: bookingList.length,
//                 itemBuilder: (context, index) {
//                   final item = bookingList[index];
//                   final booking = item.booking;
//                   final room = item.roomDetail;
//
//                   DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
//                   String checkInDate = dateFormat.format(DateTime.parse(booking.checkIn));
//                   String checkOutDate = dateFormat.format(DateTime.parse(booking.checkOut));
//                   String createdAtDate = dateFormat.format(DateTime.parse(booking.createdAt));
//
//                   Color statusColor;
//                   String statusText;
//                   switch (booking.status) {
//                     case 'PENDING':
//                       statusColor = Colors.grey;
//                       statusText = 'Đang chờ';
//                       break;
//                     case 'CONFIRMED':
//                       statusColor = Colors.green;
//                       statusText = 'Đã xác nhận';
//                       break;
//                     case 'CANCELLED':
//                       statusColor = Colors.red;
//                       statusText = 'Bị hủy';
//                       break;
//                     default:
//                       statusColor = Colors.grey;
//                       statusText = 'Không xác định';
//                   }
//
//                   final priceFormatted = NumberFormat("#,###", "vi_VN").format(booking.price);
//
//                   return Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: Alignment.center,
//                             child: Column(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.network(
//                                     'http://172.28.160.1:8080/api/files/${room.roomImg}',
//                                     width: 110,
//                                     height: 90,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Container(
//                                   width: 70,
//                                   height: 19,
//                                   decoration: BoxDecoration(
//                                     color: statusColor,
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       statusText,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '#Booking${booking.bookingId}',
//                                   style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
//                                 ),
//                                 Text(
//                                   '${room.roomName} - ${room.hotelName}',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFF65462D),
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text('Địa chỉ: ${room.specificAddress}', style: const TextStyle(fontSize: 12)),
//                                 Text('Ngày nhận: $checkInDate', style: const TextStyle(fontSize: 12)),
//                                 Text('Ngày trả: $checkOutDate', style: const TextStyle(fontSize: 12)),
//                                 Text('Ngày tạo: $createdAtDate', style: const TextStyle(fontSize: 12)),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 if (booking.status == 'CONFIRMED')
//                                   Column(
//                                     children: [
//                                       const SizedBox(height: 30),
//
//                                       GestureDetector(
//                                         onTap: () {
//                                           String content = '';
//                                           TextEditingController reviewController = TextEditingController();
//                                           int localSelectedStars = 0;
//
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return StatefulBuilder(
//                                                 builder: (context, setState) {
//                                                   return Dialog(
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius: BorderRadius.circular(10),
//                                                     ),
//                                                     child: Container(
//                                                       height: 350,
//                                                       padding: const EdgeInsets.all(16),
//                                                       decoration: ShapeDecoration(
//                                                         color: Colors.white,
//                                                         shape: RoundedRectangleBorder(
//                                                           side: BorderSide(width: 1, color: const Color(0xFFB3B3B3)),
//                                                           borderRadius: BorderRadius.circular(10),
//                                                         ),
//                                                       ),
//                                                       child: Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           const Text(
//                                                             'Đánh giá phòng',
//                                                             style: TextStyle(
//                                                               fontSize: 18,
//                                                               fontWeight: FontWeight.bold,
//                                                               color: Color(0xFF65462D),
//                                                             ),
//                                                           ),
//                                                           const SizedBox(height: 16),
//                                                           const Text('Đánh giá: 1-5 sao', style: TextStyle(fontSize: 14)),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             children: List.generate(5, (index) {
//                                                               return IconButton(
//                                                                 icon: Icon(
//                                                                   index < localSelectedStars ? Icons.star : Icons.star_border,
//                                                                   color: Colors.yellow,
//                                                                 ),
//                                                                 onPressed: () {
//                                                                   setState(() {
//                                                                     localSelectedStars = index + 1;
//                                                                   });
//                                                                 },
//                                                               );
//                                                             }),
//                                                           ),
//                                                           const SizedBox(height: 16),
//                                                           const Text('Nhận xét:', style: TextStyle(fontSize: 14)),
//                                                           TextField(
//                                                             controller: reviewController,
//                                                             decoration: const InputDecoration(
//                                                               hintText: 'Nhập nhận xét của bạn...',
//                                                               border: OutlineInputBorder(),
//                                                             ),
//                                                             maxLines: 3,
//                                                           ),
//                                                           const SizedBox(height: 16),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                             children: [
//                                                               ElevatedButton(
//                                                                 onPressed: () {
//                                                                   Navigator.pop(context);
//                                                                 },
//                                                                 child: const Text('Đóng'),
//                                                                 style: ElevatedButton.styleFrom(
//                                                                   backgroundColor: Colors.grey,
//                                                                   foregroundColor: Colors.white,
//                                                                 ),
//                                                               ),
//                                                               ElevatedButton(
//                                                                 onPressed: () {
//                                                                   content = reviewController.text;
//                                                                   submitReview(content, localSelectedStars, booking.bookingId);
//                                                                   Navigator.pop(context);
//                                                                 },
//                                                                 child: const Text('Gửi'),
//                                                                 style: ElevatedButton.styleFrom(
//                                                                   backgroundColor: const Color(0xFF65462D),
//                                                                   foregroundColor: Colors.white,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFFA68367),
//                                             borderRadius: BorderRadius.circular(50),
//                                           ),
//                                           child: const Text(
//                                             'Đánh giá',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 if (booking.status != 'CONFIRMED')
//                                   const SizedBox(height: 50),
//                                 Text(
//                                   '$priceFormatted VND',
//                                   style: const TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFF65462D),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hotel_app/common/local/shared_prefs/get_user_login.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/review/model/booking_with_room_info.dart';
import 'package:hotel_app/features/review/model/review_response_dto.dart';
import 'package:hotel_app/features/review/service/fetch_bookings_with_room_details.dart';
import 'package:hotel_app/features/review/service/get_reviews.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingListUserScreen extends StatefulWidget {
  const BookingListUserScreen({super.key});
  // late Future<List<BookingWithRoomInfo>> bookings;

  @override
  _BookingListUserScreenState createState() => _BookingListUserScreenState();
}



class _BookingListUserScreenState extends State<BookingListUserScreen> {
  late Future<List<BookingWithRoomInfo>> bookings;

  @override
  void initState() {
    super.initState();
    _loadBookings();
    // bookings = fetchBookingsWithRoomDetails(1);
  }

  Future<void> _loadBookings() async {
    int? userId = await getUserId();
    if (userId != null) {
      bookings = fetchBookingsWithRoomDetails(userId);
      setState(() {});
    }
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Đánh giá đã được gửi!'),
      ));
      setState(() {
        _loadBookings();
        // bookings = fetchBookingsWithRoomDetails(1);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Có lỗi xảy ra khi gửi đánh giá.'),
      ));
    }
  }

  void showReviewDialog(int bookingId) {
    String content = '';
    TextEditingController reviewController = TextEditingController();
    int localSelectedStars = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 350,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFB3B3B3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đánh giá phòng',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF65462D)),
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
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white, // Màu chữ trắng
                          ),
                          child: const Text('Đóng'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            content = reviewController.text;
                            submitReview(content, localSelectedStars, bookingId);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF65462D),
                            foregroundColor: Colors.white, // Màu chữ trắng
                          ),
                          child: const Text('Gửi'),
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
  }

  void showReviewListDialog(List<int> reviewIdList) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Danh sách đánh giá'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: reviewIdList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Review ID: ${reviewIdList[index]}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
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
                  final reviewIds = item.booking.reviewIdList ?? [];

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
                          // Image + status
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'http://172.28.160.1:8080/api/files/${room.roomImg}',
                                  width: 105,
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
                          const SizedBox(width: 10),
                          // Booking info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('#Booking${booking.bookingId}', style: const TextStyle(fontSize: 10)),
                                Text(
                                  '${room.roomName} - ${room.hotelName}',
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF65462D), fontSize: 13),
                                ),
                                Text('Địa chỉ: ${room.specificAddress}', style: const TextStyle(fontSize: 12)),
                                Text('Ngày nhận: $checkInDate', style: const TextStyle(fontSize: 12)),
                                Text('Ngày trả: $checkOutDate', style: const TextStyle(fontSize: 12)),
                                Text('Ngày tạo: $createdAtDate', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 30),
                              if (booking.status == 'CONFIRMED')
                                GestureDetector(
                                  onTap: () async {
                                    if (reviewIds.isNotEmpty) {
                                      try {
                                        List<ReviewResponseDto> reviews = await getReviews(reviewIds);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Danh sách đánh giá',
                                                style: const TextStyle(
                                                  color: Color(0xFF65462D),
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              content: SizedBox(
                                                width: double.maxFinite,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: reviews.length,
                                                  itemBuilder: (context, index) {
                                                    final review = reviews[index];
                                                    return ListTile(
                                                      title: Text(
                                                        'ID: ${review.reviewId}',
                                                        style: const TextStyle(
                                                          // color: Color(0xFF65462D),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Đánh giá: ',
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: 'Inter',
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              // Icon sao
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors.yellow, // Màu vàng cho sao
                                                                size: 16, // Kích thước sao
                                                              ),
                                                              SizedBox(width: 4), // Khoảng cách giữa sao và số đánh giá
                                                              Text(
                                                                '${review.rating}',
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: 'Inter',
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          Text(
                                                            'Nhận xét: ${review.content}',
                                                            style: const TextStyle(
                                                              // color: Color(0xFF65462D),
                                                              fontSize: 14,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text(
                                                    'Đóng',
                                                    style: TextStyle(
                                                      color: Color(0xFF65462D),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        print('Lỗi khi lấy đánh giá: $e');
                                      }
                                    } else {
                                      showReviewDialog(booking.bookingId);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: reviewIds.isNotEmpty
                                          ? Colors.grey
                                          : const Color(0xFFA68367),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      reviewIds.isNotEmpty ? 'Xem đánh giá' : 'Đánh giá',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
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
