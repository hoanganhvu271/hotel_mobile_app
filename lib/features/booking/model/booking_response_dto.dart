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
  });

  factory BookingResponseDto.fromJson(Map<String, dynamic> json) {
    return BookingResponseDto(
      bookingId: json['bookingId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      price: json['price'],
      status: json['status'],
      userId: json['userId'],
      roomId: json['roomId'],
      billId: json['billId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
