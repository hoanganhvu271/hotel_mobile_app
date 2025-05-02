import '../../../models/room_image.dart';
import '../../../models/service.dart';
import 'hotel_dto.dart';

class RoomResponseDto {
  final int id;
  final String roomName;
  final double area;
  final double comboPrice2h;
  final double pricePerNight;
  final double extraHourPrice;
  final int standardOccupancy;
  final int maxOccupancy;
  final int numChildrenFree;
  final String roomImg;
  final int bedNumber;
  final double extraAdult;
  final String description;
  final HotelDto hotelDto;
  final List<Service> serviceDtoList;
  final List<RoomImage> roomImageUrls;

  RoomResponseDto({
    required this.id,
    required this.roomName,
    required this.area,
    required this.comboPrice2h,
    required this.pricePerNight,
    required this.extraHourPrice,
    required this.standardOccupancy,
    required this.maxOccupancy,
    required this.numChildrenFree,
    required this.roomImg,
    required this.bedNumber,
    required this.extraAdult,
    required this.description,
    required this.hotelDto,
    required this.serviceDtoList,
    required this.roomImageUrls,
  });

  factory RoomResponseDto.fromJson(Map<String, dynamic> json) {
    return RoomResponseDto(
      id: json['roomId'],
      roomName: json['roomName'],
      area: json['area'].toDouble(),
      comboPrice2h: json['comboPrice2h'].toDouble(),
      pricePerNight: json['pricePerNight'].toDouble(),
      extraHourPrice: json['extraHourPrice'].toDouble(),
      standardOccupancy: json['standardOccupancy'],
      maxOccupancy: json['maxOccupancy'],
      numChildrenFree: json['numChildrenFree'],
      roomImg: json['roomImg'],
      bedNumber: json['bedNumber'],
      extraAdult: json['extraAdult'].toDouble(),
      description: json['description'],
      hotelDto: HotelDto.fromJson(json['hotelDto']),
      serviceDtoList: (json['serviceDtoList'] as List)
          .map((e) => Service.fromJson(e))
          .toList(),
      roomImageUrls: (json['roomImageUrls'] as List)
          .map((e) => RoomImage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'roomId': id,
    'roomName': roomName,
    'area': area,
    'comboPrice2h': comboPrice2h,
    'pricePerNight': pricePerNight,
    'extraHourPrice': extraHourPrice,
    'standardOccupancy': standardOccupancy,
    'maxOccupancy': maxOccupancy,
    'numChildrenFree': numChildrenFree,
    'roomImg': roomImg,
    'bedNumber': bedNumber,
    'extraAdult': extraAdult,
    'description': description,
    'hotelDto': hotelDto.toJson(),
    'serviceDtoList': serviceDtoList.map((e) => e.toJson()).toList(),
    'roomImageUrls': roomImageUrls.map((e) => e.toJson()).toList(),
  };
}
