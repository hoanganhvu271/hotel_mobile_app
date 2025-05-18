import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/search_room/data/room_search_service.dart';
import 'package:hotel_app/features/search_room/model/room_search_list.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';

final roomSearchRepository = Provider<RoomSearchRepository>(
  (ref) => RoomSearchRepositoryImpl(
    roomSearchService: ref.watch(roomSearchService),
  ),
);

abstract class RoomSearchRepository {
  Future<BaseResponse<List<RoomSearchList>>> getRoomsSearch(
      SearchRequest request);
  Future<BaseResponse<List<String>>> getCities();
  Future<BaseResponse<List<String>>> getDistricts(String city);
  Future<BaseResponse<List<String>>> getServices();
}

class RoomSearchRepositoryImpl implements RoomSearchRepository {
  final RoomSearchService roomSearchService;
  RoomSearchRepositoryImpl({required this.roomSearchService});
  @override
  Future<BaseResponse<List<RoomSearchList>>> getRoomsSearch(
      SearchRequest request) async {
    return await roomSearchService.getRoomsSearchList(request);
  }

  @override
  Future<BaseResponse<List<String>>> getCities() async {
    return await roomSearchService.getCities();
  }

  @override
  Future<BaseResponse<List<String>>> getDistricts(String city) async {
    return await roomSearchService.getDistricts(city);
  }

  @override
  Future<BaseResponse<List<String>>> getServices() async {
    return await roomSearchService.getServices();
  }
}
