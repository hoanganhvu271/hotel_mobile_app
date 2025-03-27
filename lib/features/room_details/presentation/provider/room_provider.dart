import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/room_details/data/room_repository.dart';
import 'package:hotel_app/models/room_model.dart';

final roomViewmodel =
    AutoDisposeNotifierProvider<RoomNotifier, BaseState<List<RoomModel>>>(
        () => RoomNotifier());

class RoomNotifier extends AutoDisposeNotifier<BaseState<List<RoomModel>>> {
  @override
  BaseState<List<RoomModel>> build() {
    state = BaseState.none();
    return state;
  }

  void getRoomById(String id) async {
    state = BaseState.loading();
    try {
      final response = await ref.read(roomRepository).getRoomById(id);

      response.fold(
        (error) => state = BaseState.error(error),
        (response) {
          try {
            // Trích xuất dữ liệu từ Response và chuyển đổi thành RoomModel
            final Map<String, dynamic> data = response.data;
            final RoomModel roomModel = RoomModel.fromJson(data);

            // Đặt state thành success với danh sách chứa roomModel
            state = BaseState.success([roomModel]);
          } catch (e) {
            print('Error parsing room data: $e');
            state =
                BaseState.error("Failed to parse room data: ${e.toString()}");
          }
        },
      );
    } catch (e) {
      print('Error fetching room: $e');
      state = BaseState.error(e.toString());
    }
  }
}
