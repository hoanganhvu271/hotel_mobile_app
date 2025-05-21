import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/booking_details_dto.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';

final bookingDetailsViewModel = AutoDisposeNotifierProvider<BookingDetailsNotifier, BaseState<BookingDetailsDto>>(() => BookingDetailsNotifier());

class BookingDetailsNotifier extends AutoDisposeNotifier<BaseState<BookingDetailsDto>> {
  @override
  BaseState<BookingDetailsDto> build() {
    state = BaseState.none();
    return state;
  }

  void getData(int id) async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getBookingDetails(id);

      if(response.isSuccessful){
        final BookingDetailsDto data = response.successfulData!;
        state = BaseState.success(data);
      }
      else{
        // print(response.errorMessage);
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
