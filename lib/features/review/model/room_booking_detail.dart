class RoomBookingDetail {
  final String roomName;
  final String hotelName;
  final String specificAddress;
  final String roomImg;

  RoomBookingDetail({
    required this.roomName,
    required this.hotelName,
    required this.specificAddress,
    required this.roomImg,
  });

  factory RoomBookingDetail.fromJson(Map<String, dynamic> json) {
    return RoomBookingDetail(
      roomName: json['roomName'] ?? '',
      hotelName: json['hotelDto']['hotelName'] ?? '',
      specificAddress: json['hotelDto']['address']['specificAddress'] ?? '',
      roomImg: json['roomImg'] ?? '',
    );
  }
}
