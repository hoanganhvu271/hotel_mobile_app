import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/search_room/data/room_search_repository.dart';

final districtViewModel =
    AutoDisposeNotifierProvider<DistrictNotifier, BaseState<List<String>>>(
  () => DistrictNotifier(),
);

class DistrictNotifier extends AutoDisposeNotifier<BaseState<List<String>>> {
  @override
  BaseState<List<String>> build() {
    state = BaseState.none();
    return state;
  }

  void getDistricts(String city) async {
    state = BaseState.loading();
    try {
      final response = await ref.read(roomSearchRepository).getDistricts(city);
      if (response.isSuccessful) {
        final List<String> data = response.successfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
