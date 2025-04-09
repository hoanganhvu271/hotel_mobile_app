// import 'package:flutter/material.dart';
// import '../../features/booking/model/booking_room_result.dart';
//
// class BookingRoomCard extends StatelessWidget {
//   final BookingRoomResult room;
//
//   const BookingRoomCard({super.key, required this.room});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Container(
//         width: double.infinity,
//         height: 168,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.grey.shade100,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Hình ảnh phòng
//             Positioned(
//               left: 9,
//               top: 9,
//               child: Container(
//                 width: 179,
//                 height: 112,
//                 decoration: ShapeDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(
//                         room.roomImg != null
//                             ? 'http://172.28.160.1:8080/api/files/${room.roomImg}'
//                             : 'https://placehold.co/179x112'
//                     ),
//
//                     fit: BoxFit.cover,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Thông tin bên phải
//             Positioned(
//               left: 210,
//               top: 30,
//               child: SizedBox(
//                 width: 160,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       room.hotelName,
//                       style: const TextStyle(
//                         color: Color(0xFF65462D),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       room.roomName,
//                       style: const TextStyle(
//                         color: Color(0xFF65462D),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       '${room.price} VNĐ',
//                       style: const TextStyle(
//                         color: Color(0xFF65462D),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Nút đặt phòng
//             Positioned(
//               left: 9,
//               bottom: 8,
//               child: Container(
//                 width: 179,
//                 height: 32,
//                 decoration: ShapeDecoration(
//                   color: const Color(0xFFA68367),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Đặt phòng',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: 0.1,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../features/booking/model/booking_room_result.dart';

class BookingRoomCard extends StatelessWidget {
  final BookingRoomResult room;

  const BookingRoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Hình ảnh phòng
            Positioned(
              left: 9,
              top: 9,
              child: Container(
                width: 179,
                height: 112,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      room.roomImg != null && room.roomImg!.isNotEmpty
                          ? 'http://172.28.160.1:8080/api/files/${room.roomImg}'
                          : 'https://placehold.co/179x112',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Thông tin bên phải
            Positioned(
              left: 200,
              top: 30,
              right: 12,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.hotelName,
                      style: const TextStyle(
                        color: Color(0xFF65462D),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.roomName,
                      style: const TextStyle(
                        color: Color(0xFF65462D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${room.price.toStringAsFixed(0)} VNĐ',
                      style: const TextStyle(
                        color: Color(0xFF65462D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Địa chỉ: ${room.address}',
                      style: const TextStyle(
                        color: Color(0xFF65462D),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Nút đặt phòng
            Positioned(
              left: 9,
              bottom: 8,
              child: Container(
                width: 179,
                height: 32,
                decoration: ShapeDecoration(
                  color: const Color(0xFFA68367),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Đặt phòng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
