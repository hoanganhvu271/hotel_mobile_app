class BookingResponseDto {
  final int bookingId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double price;
  final String status;
  final int userId;
  final int roomId;
  final int billId;
  final DateTime createdAt;
  final List<int> reviewIdList;

  BookingResponseDto({
    required this.bookingId,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.status,
    required this.userId,
    required this.roomId,
    required this.billId,
    required this.createdAt,
    required this.reviewIdList,
  });

  factory BookingResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingResponseDto(
      bookingId: json['bookingId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      price: json['price'] is double
          ? json['price']
          : double.parse(json['price'].toString()),
      status: json['status'],
      userId: json['userId'],
      roomId: json['roomId'],
      billId: json['billId'],
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
      'userId': userId,
      'roomId': roomId,
      'billId': billId,
      'createdAt': createdAt.toIso8601String(),
      'reviewIdList': reviewIdList,
    };
  }
}
