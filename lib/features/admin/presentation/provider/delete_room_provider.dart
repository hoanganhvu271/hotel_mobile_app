import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/presentation/provider/room_provider.dart'; // Import for refreshing room list

// Enum để đại diện cho các trạng thái kiểm tra
enum CheckRoomState {
  none,
  checking,
  canDelete,
  hasBookings,
  error
}

// Định nghĩa trạng thái mới bao gồm cả trạng thái kiểm tra
class DeleteRoomState {
  final BaseStatus status;
  final bool? success;
  final String? message;
  final CheckRoomState checkState;

  DeleteRoomState({
    required this.status,
    this.success,
    this.message,
    this.checkState = CheckRoomState.none,
  });

  DeleteRoomState copyWith({
    BaseStatus? status,
    bool? success,
    String? message,
    CheckRoomState? checkState,
  }) {
    return DeleteRoomState(
      status: status ?? this.status,
      success: success ?? this.success,
      message: message ?? this.message,
      checkState: checkState ?? this.checkState,
    );
  }
}

final deleteRoomProvider = AutoDisposeNotifierProvider<DeleteRoomNotifier, DeleteRoomState>(
      () => DeleteRoomNotifier(),
);

class DeleteRoomNotifier extends AutoDisposeNotifier<DeleteRoomState> {
  @override
  DeleteRoomState build() {
    // Initial state is none (no deletion in progress)
    return DeleteRoomState(status: BaseStatus.none);
  }

  // Kiểm tra xem phòng có booking nào không trước khi xóa
  Future<void> checkRoomBeforeDelete(int roomId) async {
    state = DeleteRoomState(
        status: BaseStatus.loading,
        checkState: CheckRoomState.checking
    );

    try {
      final response = await ref.read(hotelOwnerRepository).checkRoomHasBookings(roomId);

      if (response.isSuccessful) {
        final hasBookings = response.successfulData!;

        if (hasBookings) {
          // Có booking, không thể xóa
          state = DeleteRoomState(
              status: BaseStatus.error,
              message: "Phòng này đang được đặt, không thể xóa",
              checkState: CheckRoomState.hasBookings
          );
        } else {
          // Không có booking, có thể xóa
          state = DeleteRoomState(
              status: BaseStatus.success,
              checkState: CheckRoomState.canDelete
          );
        }
      } else {
        // Lỗi khi kiểm tra
        state = DeleteRoomState(
            status: BaseStatus.error,
            message: response.errorMessage ?? "Lỗi khi kiểm tra trạng thái phòng",
            checkState: CheckRoomState.error
        );
      }
    } catch (e) {
      state = DeleteRoomState(
          status: BaseStatus.error,
          message: e.toString(),
          checkState: CheckRoomState.error
      );
    }
  }

  // Hàm xóa phòng
  Future<void> deleteRoom(int roomId) async {
    // Đầu tiên kiểm tra trạng thái phòng
    await checkRoomBeforeDelete(roomId);

    // Chỉ tiếp tục nếu phòng có thể xóa được
    if (state.checkState == CheckRoomState.canDelete) {
      state = DeleteRoomState(status: BaseStatus.loading);

      try {
        final response = await ref.read(hotelOwnerRepository).deleteRoom(roomId);

        if (response.isSuccessful) {
          state = DeleteRoomState(
              status: BaseStatus.success,
              success: true
          );

          // Refresh danh sách phòng
          await ref.read(roomViewModel.notifier).refresh();
        } else {
          state = DeleteRoomState(
              status: BaseStatus.error,
              message: response.errorMessage ?? "Failed to delete room"
          );
        }
      } catch (e) {
        state = DeleteRoomState(
            status: BaseStatus.error,
            message: e.toString()
        );
      }
    }
    // Nếu không thể xóa, trạng thái đã được cập nhật trong checkRoomBeforeDelete
  }

  void reset() {
    state = DeleteRoomState(status: BaseStatus.none);
  }
}