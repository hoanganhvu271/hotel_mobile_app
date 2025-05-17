class PutRoomRequest {
  final int roomId;
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
  final List<int> serviceIds; // Added this field
  final List<int> editImageIdList;

  PutRoomRequest({
    required this.roomId,
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
    required this.serviceIds, // Added this parameter
    required this.editImageIdList,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
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
      'serviceIds': serviceIds, // Added this field to JSON
      'roomImageUrls': editImageIdList,
    };
  }
}