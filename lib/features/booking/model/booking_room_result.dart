// class BookingRoomResult {
//   final int roomId;
//   final String roomName;
//   final double price;
//   final String hotelName;
//   final String address;
//   final List<String> services;
//   final String checkIn;
//   final String checkOut;
//   final String? roomImg;
//   final int adults;
//   final int children;
//   final int bedNumber;
//
//   BookingRoomResult({
//     required this.roomId,
//     required this.roomName,
//     required this.price,
//     required this.hotelName,
//     required this.address,
//     required this.services,
//     required this.checkIn,
//     required this.checkOut,
//     required this.roomImg,
//     required this.adults,
//     required this.children,
//     required this.bedNumber,
//   });
//
//   factory BookingRoomResult.fromJson(Map<String, dynamic> json) {
//     return BookingRoomResult(
//       roomId: json['roomId'],
//       roomName: json['roomName'],
//       price: (json['price'] as num).toDouble(),
//       hotelName: json['hotelName'],
//       address: json['address'],
//       services: List<String>.from(json['services']),
//       checkIn: json['checkIn'],
//       checkOut: json['checkOut'],
//       roomImg: json['roomImg'] ?? "",
//       adults: json['adults'],
//       children: json['children'],
//       bedNumber: json['bedNumber'],
//     );
//   }
// }


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
  final int adults;
  final int children;
  final int bedNumber;
  final double rating; // ✅ Thêm dòng này

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
    required this.adults,
    required this.children,
    required this.bedNumber,
    required this.rating,
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
      adults: json['adults'],
      children: json['children'],
      bedNumber: json['bedNumber'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
