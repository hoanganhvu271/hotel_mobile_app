import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/search_room/data/serach_entry_repository.dart';
import 'package:hotel_app/features/search_room/model/search_entry.dart';

final searchEntryViewModel = AutoDisposeNotifierProvider<SearchEntryNotifier,
    BaseState<List<SearchEntry>>>(
  () => SearchEntryNotifier(),
);

class SearchEntryNotifier
    extends AutoDisposeNotifier<BaseState<List<SearchEntry>>> {
  @override
  BaseState<List<SearchEntry>> build() {
    state = BaseState.none();
    return state;
  }

  void getSearchEntries(String query) async {
    state = BaseState.loading();
    try {
      final response =
          await ref.read(searchEntryRepository).getSearchEntries(query);
      if (response.isSuccessful) {
        final List<SearchEntry> data = response.successfulData!;
        state = BaseState.success(data);
      } else {
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
