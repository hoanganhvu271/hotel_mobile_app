class BookingUserResult {
  final int bookingId;
  final String checkIn;
  final String checkOut;
  final double price;
  final String status;
  final int userId;
  final int roomId;
  final int billId;
  final String createdAt;

  BookingUserResult({
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

  factory BookingUserResult.fromJson(Map<String, dynamic> json) {
    return BookingUserResult(
      bookingId: json['bookingId'] ?? 0,
      checkIn: json['checkIn'] ?? '',
      checkOut: json['checkOut'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      userId: json['userId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      billId: json['billId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
