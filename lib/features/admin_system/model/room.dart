class Room {
  final int roomId;
  final String roomName;
  final String roomImg;

  Room({
    required this.roomId,
    required this.roomName,
    required this.roomImg,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      roomName: json['roomName'],
      roomImg: json['roomImg'],
    );
  }
}
