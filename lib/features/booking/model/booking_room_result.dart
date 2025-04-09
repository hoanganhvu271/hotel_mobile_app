class BookingRoomResult {
  final int roomId;
  final String roomName;
  final double price;
  final String hotelName;
  final String address;
  final List<String> services;
  final String checkIn;
  final String checkOut;
  final String? roomImg;

  BookingRoomResult({
    required this.roomId,
    required this.roomName,
    required this.price,
    required this.hotelName,
    required this.address,
    required this.services,
    required this.checkIn,
    required this.checkOut,
    required this.roomImg,
  });

  factory BookingRoomResult.fromJson(Map<String, dynamic> json) {
    return BookingRoomResult(
      roomId: json['roomId'],
      roomName: json['roomName'],
      price: (json['price'] as num).toDouble(),
      hotelName: json['hotelName'],
      address: json['address'],
      services: List<String>.from(json['services']),
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      roomImg: json['roomImg'] ?? "",
    );
  }
}
