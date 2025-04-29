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

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"] ?? '',
    district: json["district"] ?? '',
    ward: json["ward"] ?? '',
    specificAddress: json["specificAddress"] ?? '',
  );

  String get fullAddress => '$specificAddress, $ward, $district, $city';
}


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

  factory HotelDto.fromJson(Map<String, dynamic> json) => HotelDto(
    hotelId: json["hotelId"] ?? 0,
    hotelName: json["hotelName"] ?? 'Unknown Hotel',
    address: Address.fromJson(json["address"] ?? {}),
    userId: json["userId"] ?? 0,
  );
}

class RoomDto {
  final int roomId;
  final String roomName;
  final double? pricePerNight;
  final String? roomImg;
  final HotelDto hotelDto;

  RoomDto({
    required this.roomId,
    required this.roomName,
    this.pricePerNight,
    this.roomImg,
    required this.hotelDto,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) => RoomDto(
    roomId: json["roomId"] ?? 0,
    roomName: json["roomName"] ?? 'Unknown Room',
    pricePerNight: (json["pricePerNight"] as num?)?.toDouble(),
    roomImg: json["roomImg"],
    hotelDto: HotelDto.fromJson(json["hotelDto"] ?? {}),
  );
}

class UserDto {
  final int userId;
  final String fullName;
  final String phone;

  UserDto({
    required this.userId,
    required this.fullName,
    required this.phone,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    userId: json["userId"] ?? 0,
    fullName: json["fullName"] ?? 'Unknown User',
    phone: json["phone"] ?? '',
  );
}


class BookingDetail {
  final int bookingId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double price;
  final String status;
  final UserDto userDto;
  final RoomDto roomDto;
  final DateTime createdAt;

  BookingDetail({
    required this.bookingId,
    required this.checkIn,
    required this.checkOut,
    required this.price,
    required this.status,
    required this.userDto,
    required this.roomDto,
    required this.createdAt,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        print("Error parsing date: $dateStr");
        return null;
      }
    }

    DateTime? checkInDate = parseDate(json["checkIn"]);
    DateTime? checkOutDate = parseDate(json["checkOut"]);
    DateTime? createdDate = parseDate(json["createdAt"]);
    if (checkInDate == null || checkOutDate == null || createdDate == null) {
      throw FormatException("Invalid date format in booking data: ${json['bookingId']}");
    }

    return BookingDetail(
      bookingId: json["bookingId"] ?? 0,
      checkIn: checkInDate,
      checkOut: checkOutDate,
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      status: json["status"] ?? 'UNKNOWN',
      userDto: UserDto.fromJson(json["userDto"] ?? {}),
      roomDto: RoomDto.fromJson(json["roomDto"] ?? {}),
      createdAt: createdDate,
    );
  }
  int get durationInDays {
    DateTime start = DateTime(checkIn.year, checkIn.month, checkIn.day);
    DateTime end = DateTime(checkOut.year, checkOut.month, checkOut.day);
    int diff = end.difference(start).inDays;
    return diff > 0 ? diff : 1;
  }
}