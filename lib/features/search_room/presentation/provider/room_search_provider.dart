import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/search_room/data/room_search_repository.dart';
import 'package:hotel_app/features/search_room/model/room_search_list.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';

final roomSearchViewModel = AutoDisposeNotifierProvider<RoomSearchNotifier,
    BaseState<List<RoomSearchList>>>(
  () => RoomSearchNotifier(),
);

class RoomSearchNotifier
    extends AutoDisposeNotifier<BaseState<List<RoomSearchList>>> {
  @override
  BaseState<List<RoomSearchList>> build() {
    state = BaseState.none();
    return state;
  }

  void getRoomsSearch(SearchRequest request) async {
    state = BaseState.loading();
    try {
      final response =
          await ref.read(roomSearchRepository).getRoomsSearch(request);
      if (response.isSuccessful) {
        final List<RoomSearchList> data = response.sucessfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
