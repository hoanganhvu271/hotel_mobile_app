import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/model/hotel_response.dart';

final hotelInfoViewModel = AutoDisposeNotifierProvider<HotelInfoProvider, BaseState<Hotel>>(
        () => HotelInfoProvider()
);

class HotelInfoProvider extends AutoDisposeNotifier<BaseState<Hotel>> {
  @override
  BaseState<Hotel> build() {
    state = BaseState.none();
    // Fetch hotel info when provider is initialized
    getHotelInfo();
    return state;
  }

  Future<void> getHotelInfo() async {
    // We'll use hotel ID 1 as default, but you could make this configurable
    const int hotelId = 1;

    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getHotelInfo(hotelId);

      if (response.isSuccessful) {
        final Hotel data = response.successfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "Failed to load hotel information");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}