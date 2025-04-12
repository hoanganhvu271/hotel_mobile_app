class Booking {
  final int bookingId;
  final String checkIn;
  final String checkOut;
  final double price;
  final String status;
  final int userId;
  final int roomId;
  final int? billId;

  Booking({
    required this.bookingId,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.status,
    required this.userId,
    required this.roomId,
    this.billId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      price: json['price'].toDouble(),
      status: json['status'],
      userId: json['userId'],
      roomId: json['roomId'],
      billId: json['billId'],
    );
  }
}
