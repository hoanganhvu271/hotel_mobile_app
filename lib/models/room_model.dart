class RoomModel {
  int roomId;
  int hotelId;
  String roomName;
  double area;
  double pricePerHour;
  double pricePerNight;
  double extraHourPrice;
  int standardOccupancy;
  int maxOccupancy;
  int numChildrenFree;
  int availableRoom;
  String roomImg;
  int bedNumber;

  RoomModel({
    required this.roomId,
    required this.hotelId,
    required this.roomName,
    required this.area,
    required this.pricePerHour,
    required this.pricePerNight,
    required this.extraHourPrice,
    required this.standardOccupancy,
    required this.maxOccupancy,
    required this.numChildrenFree,
    required this.availableRoom,
    required this.roomImg,
    required this.bedNumber,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'],
      hotelId: json['hotelId'],
      roomName: json['roomName'],
      area: json['area'],
      pricePerHour: json['pricePerHour'],
      pricePerNight: json['pricePerNight'],
      extraHourPrice: json['extraHourPrice'],
      standardOccupancy: json['standardOccupancy'],
      maxOccupancy: json['maxOccupancy'],
      numChildrenFree: json['numChildrenFree'],
      availableRoom: json['availableRoom'],
      roomImg: json['roomImg'],
      bedNumber: json['bedNumber'],
    );
  }
}
