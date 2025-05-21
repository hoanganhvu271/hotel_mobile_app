import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/room_details/model/room_details.dart';
import 'package:hotel_app/features/room_details/data/room_details_service.dart';

final roomDetailsRepository = Provider<RoomDetailsRepositoryImpl>(
  (ref) => RoomDetailsRepositoryImpl(
    roomDetailsService: ref.watch(roomDetailsSerivce),
  ),
);

abstract class RoomDetailsRepository {
  Future<BaseResponse<RoomDetails>> getRoomDetails(int id);
}

class RoomDetailsRepositoryImpl implements RoomDetailsRepository {
  final RoomDetailsService roomDetailsService;
  RoomDetailsRepositoryImpl({required this.roomDetailsService});
  @override
  Future<BaseResponse<RoomDetails>> getRoomDetails(int id) async {
    return await roomDetailsService.getRoomDetails(id);
  }
}
