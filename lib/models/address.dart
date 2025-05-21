class Address {
  final int? addressId;
  final String city;
  final String district;
  final String ward;
  final String specificAddress;

  Address({
    this.addressId,
    required this.city,
    required this.district,
    required this.ward,
    required this.specificAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['addressId'],
      city: json['city'],
      district: json['district'],
      ward: json['ward'],
      specificAddress: json['specificAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'city': city,
      'district': district,
      'ward': ward,
      'specificAddress': specificAddress,
    };
  }
}
