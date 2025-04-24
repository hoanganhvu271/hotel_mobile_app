class RoomSearchList {
  final int roomId;
  final String roomName;
  final String hotelName;
  final double area;
  final int standardOccupancy;
  final String roomImg;
  final int bedNumber;
  final double rating;
  final int reviewCount;
  final String address;

  RoomSearchList({
    required this.roomId,
    required this.roomName,
    required this.hotelName,
    required this.area,
    required this.standardOccupancy,
    required this.roomImg,
    required this.bedNumber,
    required this.rating,
    required this.reviewCount,
    required this.address,
  });

  // Create from JSON
  factory RoomSearchList.fromJson(Map<String, dynamic> json) {
    return RoomSearchList(
      roomId: json['roomId'] as int,
      roomName: json['roomName'] as String,
      hotelName: json['hotelName'] as String,
      area: json['area'] as double,
      standardOccupancy: json['standardOccupancy'] as int,
      roomImg: json['roomImg'] as String,
      bedNumber: json['bedNumber'] as int,
      rating: json['rating'] as double,
      reviewCount: json['reviewCount'] as int,
      address: json['address'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'hotelName': hotelName,
      'area': area,
      'standardOccupancy': standardOccupancy,
      'roomImg': roomImg,
      'bedNumber': bedNumber,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
    };
  }

  // Create a copy with some fields changed
  RoomSearchList copyWith({
    int? roomId,
    String? roomName,
    String? hotelName,
    double? area,
    int? standardOccupancy,
    String? roomImg,
    int? bedNumber,
    double? rating,
    int? reviewCount,
    String? address,
  }) {
    return RoomSearchList(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      hotelName: hotelName ?? this.hotelName,
      area: area ?? this.area,
      standardOccupancy: standardOccupancy ?? this.standardOccupancy,
      roomImg: roomImg ?? this.roomImg,
      bedNumber: bedNumber ?? this.bedNumber,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      address: address ?? this.address,
    );
  }

  // For equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomSearchList &&
          runtimeType == other.runtimeType &&
          roomId == other.roomId &&
          roomName == other.roomName &&
          hotelName == other.hotelName &&
          area == other.area &&
          standardOccupancy == other.standardOccupancy &&
          roomImg == other.roomImg &&
          bedNumber == other.bedNumber &&
          rating == other.rating &&
          reviewCount == other.reviewCount;

  @override
  int get hashCode =>
      roomId.hashCode ^
      roomName.hashCode ^
      hotelName.hashCode ^
      area.hashCode ^
      standardOccupancy.hashCode ^
      roomImg.hashCode ^
      bedNumber.hashCode ^
      rating.hashCode ^
      reviewCount.hashCode;

  @override
  String toString() {
    return 'RoomSearchList{roomId: $roomId, roomName: $roomName, hotelName: $hotelName, area: $area, standardOccupancy: $standardOccupancy, roomImg: $roomImg, bedNumber: $bedNumber, rating: $rating, reviewCount: $reviewCount, address: $address}';
  }
}
