import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/search_room/data/room_search_repository.dart';
import 'package:hotel_app/features/search_room/model/service.dart';

final serviceViewModel =
    AutoDisposeNotifierProvider<ServiceProvider, BaseState<List<Service>>>(
  () => ServiceProvider(),
);

class ServiceProvider extends AutoDisposeNotifier<BaseState<List<Service>>> {
  @override
  BaseState<List<Service>> build() {
    state = BaseState.none();
    return state;
  }

  void getServices() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(roomSearchRepository).getServices();
      if (response.isSuccessful) {
        final List<dynamic> data = response.sucessfulData!;
        state = BaseState.success(
            data.map((json) => Service.fromJson(json)).toList());
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
