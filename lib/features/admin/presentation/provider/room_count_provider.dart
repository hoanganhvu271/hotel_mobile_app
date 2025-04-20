import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';
import '../../model/room_response_dto.dart';

final roomCountViewModel = AutoDisposeNotifierProvider<RoomCountNotifier, BaseState<List<RoomResponseDto>>>(() => RoomCountNotifier());

class RoomCountNotifier extends AutoDisposeNotifier<BaseState<List<RoomResponseDto>>> {
  @override
  BaseState<List<RoomResponseDto>> build() {
    state = BaseState.none();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getAllRooms(1);

      if(response.isSuccessful){
        final List<RoomResponseDto> data = response.successfulData!;
        state = BaseState.success(data ?? []);
      }
      else{
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
