import 'package:hotel_app/features/admin/model/user_dto.dart';

class BookingResponseDto {
  final int? bookingId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? price;
  final String? status;
  final UserDto? user;
  final String? roomName;
  final int? billId;
  final DateTime? createdAt;
  final List<int>? reviewIdList;

  BookingResponseDto({
    this.bookingId,
    this.checkIn,
    this.checkOut,
    this.price,
    this.status,
    this.user,
    this.roomName,
    this.billId,
    this.createdAt,
    this.reviewIdList,
  });

  factory BookingResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingResponseDto(
      bookingId: json['bookingId'],
      checkIn: json['checkIn'] != null ? DateTime.parse(json['checkIn']) : null,
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'],
      user: json['user'] != null ? UserDto.fromJson(json['user']) : null,
      roomName: json['roomName'],
      billId: json['billId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      reviewIdList: (json['reviewIdList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'checkIn': checkIn?.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'price': price,
      'status': status,
      'user': user?.toJson(),
      'roomName': roomName,
      'billId': billId,
      'createdAt': createdAt?.toIso8601String(),
      'reviewIdList': reviewIdList,
    };
  }
}
