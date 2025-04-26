class Hotel {
  final int hotelId;
  final String hotelName;
  final Address address;
  final int userId;

  Hotel({
    required this.hotelId,
    required this.hotelName,
    required this.address,
    required this.userId,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      address: Address.fromJson(json['address']),
      userId: json['userId'],
    );
  }
}

class Address {
  final String city;
  final String district;
  final String ward;
  final String specificAddress;

  Address({
    required this.city,
    required this.district,
    required this.ward,
    required this.specificAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      district: json['district'],
      ward: json['ward'],
      specificAddress: json['specificAddress'],
    );
  }
}
