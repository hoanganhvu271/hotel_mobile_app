import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/room_details/model/review.dart';
import '../../features/room_details/model/room_details.dart';

final compareRoomIdProvider = StateProvider<int>((ref) => 0);

final compareRoomProvider =
    StateNotifierProvider<CompareRoomState, RoomDetails>((ref) {
  return CompareRoomState();
});

class CompareRoomState extends StateNotifier<RoomDetails> {
  CompareRoomState() : super(RoomDetails());

  // === FULL GETTER ===
  int? get roomId => state.roomId;
  String? get roomName => state.roomName;
  double? get area => state.area;
  double? get comboPrice2h => state.comboPrice2h;
  double? get pricePerNight => state.pricePerNight;
  double? get extraHourPrice => state.extraHourPrice;
  int? get standardOccupancy => state.standardOccupancy;
  int? get maxOccupancy => state.maxOccupancy;
  int? get numChildrenFree => state.numChildrenFree;
  List<String>? get roomImgs => state.roomImgs;
  int? get bedNumber => state.bedNumber;
  double? get extraAdult => state.extraAdult;
  String? get description => state.description;
  String? get hotelName => state.hotelName;
  String? get address => state.address;
  List<String>? get services => state.services;
  List<Review>? get reviews => state.reviews;

  // === SET toàn bộ state ===
  void setRoomDetails(RoomDetails newDetails) {
    state = newDetails;
  }

  // === CLEAR state ===
  void clearRoomDetails() {
    state = RoomDetails(); // reset về mặc định
  }
}
