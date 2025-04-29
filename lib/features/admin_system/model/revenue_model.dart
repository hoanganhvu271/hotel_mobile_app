class RevenueModel {
  final List<BookingDetail> bookingDetailList;
  final double totalRevenue;

  RevenueModel({required this.bookingDetailList, required this.totalRevenue});

  factory RevenueModel.fromJson(Map<String, dynamic> json) {
    var list = json['bookingDetailList'] as List;
    List<BookingDetail> bookingDetails =
    list.map((i) => BookingDetail.fromJson(i)).toList();

    return RevenueModel(
      bookingDetailList: bookingDetails,
      totalRevenue: json['totalRevenue'].toDouble(),
    );
  }
}

class BookingDetail {
  final int bookingId;
  final String roomName;
  final String fullName;
  final String phone;
  final String checkIn;
  final String checkOut;
  final double price;
  final String createAt;

  BookingDetail({
    required this.bookingId,
    required this.roomName,
    required this.fullName,
    required this.phone,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.createAt,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      bookingId: json['bookingId'],
      roomName: json['roomName'],
      fullName: json['fullName'],
      phone: json['phone'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      price: json['price'].toDouble(),
      createAt: json['createAt'],
    );
  }
}
