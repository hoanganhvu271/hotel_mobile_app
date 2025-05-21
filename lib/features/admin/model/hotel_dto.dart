import '../../../models/address.dart';

class HotelDto {
  final int hotelId;
  final String hotelName;
  final Address address;
  final int userId;

  HotelDto({
    required this.hotelId,
    required this.hotelName,
    required this.address,
    required this.userId,
  });

  factory HotelDto.fromJson(Map<String, dynamic> json) {
    return HotelDto(
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      address: Address.fromJson(json['address']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'hotelId': hotelId,
    'hotelName': hotelName,
    'address': address.toJson(),
    'userId': userId,
  };
}
