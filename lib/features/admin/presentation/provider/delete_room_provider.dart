import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/presentation/provider/room_provider.dart'; // Import for refreshing room list


final deleteRoomProvider = AutoDisposeNotifierProvider<DeleteRoomNotifier, BaseState<bool>>(
      () => DeleteRoomNotifier(),
);

class DeleteRoomNotifier extends AutoDisposeNotifier<BaseState<bool>> {
  @override
  BaseState<bool> build() {
    // Initial state is none (no deletion in progress)
    state = BaseState.none();
    return state;
  }

  Future<void> deleteRoom(int roomId) async {
    state = BaseState.loading();

    try {
      final response = await ref.read(hotelOwnerRepository).deleteRoom(roomId);

      if (response.isSuccessful) {
        state = BaseState.success(true);

        await ref.read(roomViewModel.notifier).refresh();
      } else {
        // Room deletion failed with an error message
        state = BaseState.error(response.errorMessage ?? "Failed to delete room");
      }
    } catch (e) {
      // Handle any exceptions during the deletion process
      state = BaseState.error(e.toString());
    }
  }

  void reset() {
    state = BaseState.none();
  }

  Future<void> deleteRoomWithCallback(
      int roomId,
      {Function? onSuccess, Function(String)? onError}
      ) async {
    state = BaseState.loading();

    try {
      final response = await ref.read(hotelOwnerRepository).deleteRoom(roomId);

      if (response.isSuccessful) {
        state = BaseState.success(true);

        // Refresh room list
        await ref.read(roomViewModel.notifier).refresh();

        // Call success callback if provided
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        final errorMsg = response.errorMessage ?? "Failed to delete room";
        state = BaseState.error(errorMsg);

        // Call error callback if provided
        if (onError != null) {
          onError(errorMsg);
        }
      }
    } catch (e) {
      state = BaseState.error(e.toString());

      // Call error callback if provided
      if (onError != null) {
        onError(e.toString());
      }
    }
  }

  Future<bool> canDeleteRoom(int roomId) async {
    return true;
  }
}