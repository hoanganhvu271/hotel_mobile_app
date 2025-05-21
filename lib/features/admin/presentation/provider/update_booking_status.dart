import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import 'package:hotel_app/features/admin/model/booking_status.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';

final updateBookingStatusViewModel = AutoDisposeNotifierProvider<UpdateBookingStatusNotifier, BaseState<bool>>(() => UpdateBookingStatusNotifier());

class UpdateBookingStatusNotifier extends AutoDisposeNotifier<BaseState<bool>> {
  @override
  BaseState<bool> build() {
    state = BaseState.none();
    return state;
  }

  void update(int bookingId, BookingStatus status) async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).updateBookingStatus(bookingId, status);

      if(response.isSuccessful){
        final bool data = response.successfulData!;
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