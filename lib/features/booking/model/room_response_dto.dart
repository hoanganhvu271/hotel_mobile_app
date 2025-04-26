class RoomResponseDto {
  final String roomImg;
  final String hotelName;
  final String roomImageUrl;

  RoomResponseDto({
    required this.roomImg,
    required this.hotelName,
    required this.roomImageUrl,
  });

  factory RoomResponseDto.fromJson(Map<String, dynamic> json) {
    return RoomResponseDto(
      roomImg: json['roomImg'],
      hotelName: json['hotelDto']['hotelName'],
      roomImageUrl: json['roomImageUrls'].isNotEmpty ? json['roomImageUrls'][0] : '', // Lấy URL ảnh phòng, nếu có
    );
  }
}
