import 'package:hotel_app/features/admin/model/user_dto.dart';
import 'bill_response_dto.dart';

class BookingDetailsDto {
  final int bookingId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double price;
  final String status;
  final UserDto user;
  final String roomName;
  final BillResponseDto? bill; // nullable
  final DateTime createdAt;
  final List<int> reviewIdList;

  BookingDetailsDto({
    required this.bookingId,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.status,
    required this.user,
    required this.roomName,
    required this.bill,
    required this.createdAt,
    required this.reviewIdList,
  });

  factory BookingDetailsDto.fromJson(Map<String, dynamic> json) {
    return BookingDetailsDto(
      bookingId: json['bookingId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      user: UserDto.fromJson(json['user']),
      roomName: json['roomName'],
      bill: json['bill'] != null ? BillResponseDto.fromJson(json['bill']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      reviewIdList: List<int>.from(json['reviewIdList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'price': price,
      'status': status,
      'user': user.toJson(),
      'roomName': roomName,
      'bill': bill?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'reviewIdList': reviewIdList,
    };
  }
}
