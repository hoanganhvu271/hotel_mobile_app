import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/search_room/data/room_search_repository.dart';

final cityViewModel =
    AutoDisposeNotifierProvider<CityNotifier, BaseState<List<String>>>(
  () => CityNotifier(),
);

class CityNotifier extends AutoDisposeNotifier<BaseState<List<String>>> {
  @override
  BaseState<List<String>> build() {
    state = BaseState.none();
    return state;
  }

  void getCities() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(roomSearchRepository).getCities();
      if (response.isSuccessful) {
        final List<String> data = response.sucessfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
