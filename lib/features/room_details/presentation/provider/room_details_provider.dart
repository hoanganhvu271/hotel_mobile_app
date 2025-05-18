import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/room_details/data/room_details_repository.dart';
import 'package:hotel_app/features/room_details/model/room_details.dart';

final roomDetailsViewModel =
    AutoDisposeNotifierProvider<RoomDetailsNotifier, BaseState<RoomDetails>>(
  () => RoomDetailsNotifier(),
);

class RoomDetailsNotifier extends AutoDisposeNotifier<BaseState<RoomDetails>> {
  @override
  BaseState<RoomDetails> build() {
    state = BaseState.none();
    return state;
  }

  void getRoomDetails(int roomId) async {
    state = BaseState.loading();
    try {
      final response =
          await ref.read(roomDetailsRepository).getRoomDetails(roomId);
      if (response.isSuccessful) {
        final RoomDetails data = response.successfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
