import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';

import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';
import '../../model/booking_stats_dto.dart';

final bookingCountViewModel = AutoDisposeNotifierProvider<BookingCount, BaseState<List<BookingResponseDto>>>(() => BookingCount());

class BookingCount extends AutoDisposeNotifier<BaseState<List<BookingResponseDto>>> {
  @override
  BaseState<List<BookingResponseDto>> build() {
    state = BaseState.none();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getAllBookings(1);

      if(response.isSuccessful){
        final List<BookingResponseDto> data = response.successfulData!;
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
