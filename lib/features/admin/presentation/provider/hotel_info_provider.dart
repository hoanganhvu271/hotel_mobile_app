import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/model/hotel_response.dart';

final hotelInfoViewModel = AutoDisposeNotifierProvider<HotelInfoProvider, BaseState<Hotel>>(() => HotelInfoProvider());

class HotelInfoProvider extends AutoDisposeNotifier<BaseState<Hotel>> {
  @override
  BaseState<Hotel> build() {
    state = BaseState.none();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getHotelInfo(1);

      if(response.isSuccessful){
        final Hotel data = response.successfulData!;
        state = BaseState.success(data);
      }
      else{
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
