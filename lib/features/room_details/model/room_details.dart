import 'package:hotel_app/features/room_details/model/review.dart';

class RoomDetails {
  final int? roomId;
  final String? roomName;
  final double? area;
  final double? comboPrice2h;
  final double? pricePerNight;
  final double? extraHourPrice;
  final int? standardOccupancy;
  final int? maxOccupancy;
  final int? numChildrenFree;
  final List<String>? roomImgs;
  final int? bedNumber;
  final double? extraAdult;
  final String? description;
  final String? hotelName;
  final String? address;
  final List<String>? services;
  final List<Review>? reviews;

  RoomDetails({
    this.roomId,
    this.roomName,
    this.area,
    this.comboPrice2h,
    this.pricePerNight,
    this.extraHourPrice,
    this.standardOccupancy,
    this.maxOccupancy,
    this.numChildrenFree,
    this.roomImgs,
    this.bedNumber,
    this.extraAdult,
    this.description,
    this.hotelName,
    this.address,
    this.services,
    this.reviews,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'roomId': roomId,
        'roomName': roomName,
        'area': area,
        'comboPrice2h': comboPrice2h,
        'pricePerNight': pricePerNight,
        'extraHourPrice': extraHourPrice,
        'standardOccupancy': standardOccupancy,
        'maxOccupancy': maxOccupancy,
        'numChildrenFree': numChildrenFree,
        'roomImgs': roomImgs,
        'bedNumber': bedNumber,
        'extraAdult': extraAdult,
        'description': description,
        'hotelName': hotelName,
        'address': address,
        'services': services,
        'reviews': reviews?.map((review) => review.toJson()).toList(),
      };

  factory RoomDetails.fromJson(Map<String, dynamic> json) {
    return RoomDetails(
      roomId: json['roomId'] as int?,
      roomName: json['roomName'] as String?,
      area: (json['area'] as num?)?.toDouble(),
      comboPrice2h: (json['comboPrice2h'] as num?)?.toDouble(),
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble(),
      extraHourPrice: (json['extraHourPrice'] as num?)?.toDouble(),
      standardOccupancy: json['standardOccupancy'] as int?,
      maxOccupancy: json['maxOccupancy'] as int?,
      numChildrenFree: json['numChildrenFree'] as int?,
      roomImgs: json['roomImgs'] != null
          ? List<String>.from(json['roomImgs'] as List)
          : null,
      bedNumber: json['bedNumber'] as int?,
      extraAdult: (json['extraAdult'] as num?)?.toDouble(),
      description: json['description'] as String?,
      hotelName: json['hotelName'] as String?,
      address: json['address'] as String?,
      services: json['services'] != null
          ? List<String>.from(json['services'] as List)
          : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
          .map((review) => Review.fromJson(review as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  // Create a copy with some fields changed
  RoomDetails copyWith({
    int? roomId,
    String? roomName,
    double? area,
    double? comboPrice2h,
    double? pricePerNight,
    double? extraHourPrice,
    int? standardOccupancy,
    int? maxOccupancy,
    int? numChildrenFree,
    List<String>? roomImgs,
    int? bedNumber,
    double? extraAdult,
    String? description,
    String? hotelName,
    String? address,
    List<String>? services,
    List<Review>? reviews,
  }) {
    return RoomDetails(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      area: area ?? this.area,
      comboPrice2h: comboPrice2h ?? this.comboPrice2h,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      extraHourPrice: extraHourPrice ?? this.extraHourPrice,
      standardOccupancy: standardOccupancy ?? this.standardOccupancy,
      maxOccupancy: maxOccupancy ?? this.maxOccupancy,
      numChildrenFree: numChildrenFree ?? this.numChildrenFree,
      roomImgs: roomImgs ?? this.roomImgs,
      bedNumber: bedNumber ?? this.bedNumber,
      extraAdult: extraAdult ?? this.extraAdult,
      description: description ?? this.description,
      hotelName: hotelName ?? this.hotelName,
      address: address ?? this.address,
      services: services ?? this.services,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  String toString() =>
      'RoomDetails(roomId: $roomId, roomName: $roomName, area: $area, '
      'comboPrice2h: $comboPrice2h, pricePerNight: $pricePerNight, '
      'extraHourPrice: $extraHourPrice, standardOccupancy: $standardOccupancy, '
      'maxOccupancy: $maxOccupancy, numChildrenFree: $numChildrenFree, '
      'roomImgs: $roomImgs, bedNumber: $bedNumber, extraAdult: $extraAdult, '
      'description: $description, hotelName: $hotelName, address: $address, '
      'services: $services, reviews: $reviews)';
}
