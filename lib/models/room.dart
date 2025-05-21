class Room {
  final int roomId;
  final int hotelId;
  final String roomName;
  final double area;
  final double pricePerHour;
  final double pricePerNight;
  final double extraHourPrice;
  final int standardOccupancy;
  final int maxOccupancy;
  final int numChildrenFree;
  final int availableRoom;
  final String roomImg;
  final int bedNumber;
  final DateTime timeCreated;

  Room({
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
    required this.timeCreated,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'],
      hotelId: json['hotel_id'],
      roomName: json['room_name'],
      area: (json['area'] as num).toDouble(),
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      extraHourPrice: (json['extra_hour_price'] as num).toDouble(),
      standardOccupancy: json['standard_occupancy'],
      maxOccupancy: json['max_occupancy'],
      numChildrenFree: json['num_children_free'],
      availableRoom: json['available_room'],
      roomImg: json['room_img'],
      bedNumber: json['bed_number'],
      timeCreated: DateTime.parse(json['time_created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'hotel_id': hotelId,
      'room_name': roomName,
      'area': area,
      'price_per_hour': pricePerHour,
      'price_per_night': pricePerNight,
      'extra_hour_price': extraHourPrice,
      'standard_occupancy': standardOccupancy,
      'max_occupancy': maxOccupancy,
      'num_children_free': numChildrenFree,
      'available_room': availableRoom,
      'room_img': roomImg,
      'bed_number': bedNumber,
      'time_created': timeCreated.toIso8601String(),
    };
  }
}
