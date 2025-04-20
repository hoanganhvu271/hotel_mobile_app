import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';

final bookingStatsViewModel = AutoDisposeNotifierProvider<BookingStatsNotifier, BaseState<List<BookingStatsDto>>>(() => BookingStatsNotifier());

class BookingStatsNotifier extends AutoDisposeNotifier<BaseState<List<BookingStatsDto>>> {
  @override
  BaseState<List<BookingStatsDto>> build() {
    state = BaseState.none();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getBookingStats(1);

      if(response.isSuccessful){
        final List<BookingStatsDto> data = response.successfulData!;
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
