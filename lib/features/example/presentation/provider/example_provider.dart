import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/core/base_state.dart';

import '../../../../models/example_model.dart';
import '../../data/example_repository.dart';

final exampleViewmodel = AutoDisposeNotifierProvider< ExampleNotifier,BaseState<List<ExampleModel>>>(() => ExampleNotifier());

class ExampleNotifier extends AutoDisposeNotifier<BaseState<List<ExampleModel>>> {
  @override
  BaseState<List<ExampleModel>> build() {
    state = BaseState.none();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(exampleRepository).getExample();

      if(response.isSuccessful){
        final List<ExampleModel> data = response.sucessfulData!;
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
