import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_service.dart';
import 'package:hotel_app/features/admin/model/hotel_dto.dart';

final userHotelsProvider = AutoDisposeNotifierProvider<UserHotelsNotifier, BaseState<List<HotelDto>>>(
        () => UserHotelsNotifier()
);

class UserHotelsNotifier extends AutoDisposeNotifier<BaseState<List<HotelDto>>> {
  @override
  BaseState<List<HotelDto>> build() {
    state = BaseState.none();
    return state;
  }

  Future<void> getUserHotels() async {
    state = BaseState.loading();
    try {
      // Gọi API thật với userID = 3
      const int userId = 3;
      final response = await ref.read(hotelOwnerService).getHotelsByUser(userId);

      if (response.isSuccessful) {
        final List<HotelDto> hotels = response.successfulData!;

        if (hotels.isEmpty) {
          state = BaseState.emptyData();
        } else {
          state = BaseState.success(hotels);
        }
      } else {
        state = BaseState.error(response.errorMessage ?? "Failed to load hotels");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}