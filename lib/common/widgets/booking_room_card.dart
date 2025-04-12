import 'package:flutter/material.dart';
import 'package:hotel_app/features/booking/booking_confirm.dart';
import 'package:intl/intl.dart';
import '../../features/booking/model/booking_room_result.dart';

class BookingRoomCard extends StatelessWidget {
  final BookingRoomResult room;
  final bool showBookButton;

  const BookingRoomCard({
    super.key,
    required this.room,
    this.showBookButton = true, // mặc định là hiển thị nút đặt phòng
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        width: double.infinity,
        height: showBookButton ? 170 : 130,
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
                      '${NumberFormat('#,###', 'vi_VN').format(room.price)} VNĐ',
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

            // Nút đặt phòng (chỉ hiển thị nếu showBookButton = true)
            if (showBookButton)
              Positioned(
                left: 9,
                bottom: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ConfirmBookingScreen(room: room),
                      ),
                    );
                  },
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
              ),
          ],
        ),
      ),
    );
  }
}
