import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/review_stats_dto.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';

final reviewStatsViewModel = AutoDisposeNotifierProvider<ReviewStatsNotifier, BaseState<ReviewStatsDto>>(() => ReviewStatsNotifier());

class ReviewStatsNotifier extends AutoDisposeNotifier<BaseState<ReviewStatsDto>> {
  @override
  BaseState<ReviewStatsDto> build() {
    state = BaseState.none();
    getExample();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getReviewStats(1);

      if(response.isSuccessful){
        final ReviewStatsDto data = response.successfulData!;
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
