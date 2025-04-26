// models/booking_schedule_models.dart (Example file name)

// Address Model (part of HotelDto)
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

// Hotel Model (part of RoomDto)
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

// Room Model (part of BookingDetail)
class RoomDto {
  final int roomId;
  final String roomName;
  final double? pricePerNight; // Optional based on your data
  final String? roomImg;       // Optional
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
    pricePerNight: (json["pricePerNight"] as num?)?.toDouble(), // Handle potential null or int
    roomImg: json["roomImg"],
    hotelDto: HotelDto.fromJson(json["hotelDto"] ?? {}),
    // Add other fields if needed (area, occupancy, etc.)
  );
}

// User Model (part of BookingDetail) - simplified
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
    // Add other fields if needed
  );
}


// Main Booking Detail Model
class BookingDetail {
  final int bookingId;
  final DateTime checkIn; // Store as DateTime
  final DateTime checkOut; // Store as DateTime
  final double price;
  final String status; // e.g., "CONFIRMED", "CANCELLED", "PENDING"
  final UserDto userDto;
  final RoomDto roomDto;
  final DateTime createdAt; // Store as DateTime

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
    // Helper to parse dates safely
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        print("Error parsing date: $dateStr");
        return null; // Return null if parsing fails
      }
    }

    DateTime? checkInDate = parseDate(json["checkIn"]);
    DateTime? checkOutDate = parseDate(json["checkOut"]);
    DateTime? createdDate = parseDate(json["createdAt"]);

    // Handle cases where dates might be missing or unparseable
    if (checkInDate == null || checkOutDate == null || createdDate == null) {
      // Decide how to handle invalid data: throw error, return default, etc.
      // For now, let's throw an error or return a placeholder if possible
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

  // Calculate the duration of the booking in days (considering only date part)
  int get durationInDays {
    // Normalize dates to midnight to compare days accurately
    DateTime start = DateTime(checkIn.year, checkIn.month, checkIn.day);
    // Checkout day is usually *not* included in the stay duration for display blocks
    // e.g., Check-in Mon, Check-out Wed means stay is Mon, Tue (2 days)
    DateTime end = DateTime(checkOut.year, checkOut.month, checkOut.day);
    // If checkout time is very early (e.g., before noon), don't include the checkout day
    // If checkout time is later, it might occupy the block for that day too.
    // For simplicity here, we assume checkout day isn't blocked.
    // Add 1 because difference gives number of transitions, not blocks.
    // If end date is same as start date, duration is 1 day.
    int diff = end.difference(start).inDays;
    return diff > 0 ? diff : 1; // Minimum 1 day duration visually
  }
}