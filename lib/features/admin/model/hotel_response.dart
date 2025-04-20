import '../../../models/address.dart';

class Hotel {
  final int hotelId;
  final String hotelName;
  final Address address;

  Hotel({
    required this.hotelId,
    required this.hotelName,
    required this.address,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotelId': hotelId,
      'hotelName': hotelName,
      'address': address.toJson(),
    };
  }
}
