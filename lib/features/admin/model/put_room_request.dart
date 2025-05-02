import '../../../models/room_image.dart';
import '../../../models/service.dart';
import 'hotel_dto.dart';

class PutRoomRequest {
  final int id;
  final String roomName;
  final double area;
  final double comboPrice2h;
  final double pricePerNight;
  final double extraHourPrice;
  final int standardOccupancy;
  final int maxOccupancy;
  final int numChildrenFree;
  final int bedNumber;
  final double extraAdult;
  final String description;
  final List<int> serviceList;
  final List<int> editImageIdList;

  PutRoomRequest({
    required this.id,
    required this.roomName,
    required this.area,
    required this.comboPrice2h,
    required this.pricePerNight,
    required this.extraHourPrice,
    required this.standardOccupancy,
    required this.maxOccupancy,
    required this.numChildrenFree,
    required this.bedNumber,
    required this.extraAdult,
    required this.description,
    required this.serviceList,
    required this.editImageIdList,
  });

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
    'bedNumber': bedNumber,
    'extraAdult': extraAdult,
    'description': description,
    'serviceDtoList': serviceList,
    'roomImageUrls': editImageIdList,
  };
}
