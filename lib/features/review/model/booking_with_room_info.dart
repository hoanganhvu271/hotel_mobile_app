import 'package:hotel_app/features/review/model/booking_user_result.dart';
import 'package:hotel_app/features/review/model/room_booking_detail.dart';

class BookingWithRoomInfo {
  final BookingUserResult booking;
  final RoomBookingDetail roomDetail;

  BookingWithRoomInfo({
    required this.booking,
    required this.roomDetail,
  });

  factory BookingWithRoomInfo.fromJson(Map<String, dynamic> json) {
    return BookingWithRoomInfo(
      booking: BookingUserResult.fromJson(json['booking']),
      roomDetail: RoomBookingDetail.fromJson(json['roomDetail']),
    );
  }

}
