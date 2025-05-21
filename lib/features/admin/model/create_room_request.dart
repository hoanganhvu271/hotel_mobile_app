class CreateRoomRequest {
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
  final int hotelId;
  final List<int> serviceIds; // Added this field

  CreateRoomRequest({
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
    required this.hotelId,
    required this.serviceIds, // Added this parameter
  });

  Map<String, dynamic> toJson() {
    return {
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
      'hotelId': hotelId,
      'serviceIds': serviceIds, // Added this field to JSON
    };
  }
}