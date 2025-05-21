import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/services_repository.dart';
import 'package:hotel_app/features/admin/model/service_model.dart';

final servicesProvider = AutoDisposeNotifierProvider<ServicesNotifier, BaseState<List<ServiceModel>>>(
      () => ServicesNotifier(),
);

class ServicesNotifier extends AutoDisposeNotifier<BaseState<List<ServiceModel>>> {
  @override
  BaseState<List<ServiceModel>> build() {
    state = BaseState.none();
    return state;
  }

  Future<void> fetchServices() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(servicesRepository).getAllServices();

      if (response.isSuccessful) {
        final List<ServiceModel> services = response.successfulData!;
        if (services.isEmpty) {
          state = BaseState.emptyData();
        } else {
          state = BaseState.success(services);
        }
      } else {
        state = BaseState.error(response.errorMessage ?? "Failed to load services");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}